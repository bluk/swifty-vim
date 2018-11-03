" Vim autoload file
" Language:         Swift
" Maintainer:       Bryant Luk <code@bryantluk.com>
" Description:      Functions to manage asynchronous jobs.

" Source code modified from original file:
" https://github.com/fatih/vim-go/blob/bc6f1df41ffc1e6beb7309aa92318e4100cc83b7/autoload/go/job.vim
"
" Copyright (c) 2015, Fatih Arslan
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"
" * Redistributions of source code must retain the above copyright notice, this
"   list of conditions and the following disclaimer.
"
" * Redistributions in binary form must reproduce the above copyright notice,
"   this list of conditions and the following disclaimer in the documentation
"   and/or other materials provided with the distribution.
"
" * Neither the name of vim-go nor the names of its
"   contributors may be used to endorse or promote products derived from
"   this software without specific prior written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
" CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
" OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
" OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function! swift#job#Spawn(args) abort
  " autowrite is not enabled for jobs
  call s:autowrite()

  let l:options = s:job_options(a:args)

  if !empty(a:args.status_type)
    let prefix = '[' . a:args.status_type . ']'
    call swift#echo#EchoSuccess(prefix . " dispatched.")
  endif

  return s:start_job(a:args.cmd, l:options)
endfunction

" Options returns callbacks to be used with job_start. It is abstracted to be
" used with various swift commands, such as build, test, etc.. This
" allows us to avoid writing the same callback over and over for some
" commands. It's fully customizable so each command can change it to its own
" logic.
"
" args is a dictionary with the these keys:
"   'jump_to_error':
"     Set to 1 to jump to the first error in the error list.
"     Defaults to 0.
"   'status_type':
"     The status type to use when updating the status.
"   'list_type':
"     The list type to use to present errors. Errors will not be handled
"     when the value is '_'. Defaults to '_job'.
"   'list_title':
"     The title to set the error list with.
"   'errorformat':
"     The errorformat string to use when parsing errors. Defaults to
"     &errorformat. See :help 'errorformat'.
"   'job_dir':
"     The directory that the job should be run in.
"     Defaults to the directory where the buffer is located in.
"
" The return value is a dictionary with these keys:
"   'callback':
"     A function suitable to be passed as a job callback handler. See
"     job-callback.
"   'exit_cb':
"     A function suitable to be passed as a job exit_cb handler. See
"     job-exit_cb.
"   'close_cb':
"     A function suitable to be passed as a job close_cb handler. See
"     job-close_cb.
"   'cwd':
"     The path to the directory which contains the current buffer. The
"     callbacks are configured to expect this directory is the working
"     directory for the job; it should not be modified by callers.
function! s:job_options(args) abort
  let callbacks = {}
  let state = {
        \ 'winid': win_getid(winnr()),
        \ 'dir': getcwd(),
        \ 'job_dir': fnameescape(expand("%:p:h")),
        \ 'messages': [],
        \ 'jump_to_error': 0,
        \ 'list_title': "",
        \ 'list_type': "_job",
        \ 'exited': 0,
        \ 'exit_status': 0,
        \ 'closed': 0,
        \ 'errorformat': &errorformat,
        \ 'status_type' : ''
      \ }

  if has_key(a:args, 'jump_to_error')
    let state.jump_to_error = a:args.jump_to_error
  endif

  if has_key(a:args, 'list_title')
    let state.list_title = a:args.list_title
  endif

  if has_key(a:args, 'list_type')
    let state.list_type = a:args.list_type
  endif

  if has_key(a:args, 'status_type')
    let state.status_type = a:args.status_type
  endif

  if has_key(a:args, 'errorformat')
    let state.errorformat = a:args.errorformat
  endif

  if has_key(a:args, 'job_dir')
    let state.job_dir = a:args.job_dir
  endif

  " vint: -ProhibitNoAbortFunction
  function state.complete(job, exit_status, data) abort
    call self.show_errors(a:job, a:exit_status, a:data)
  endfunction
  " vint: +ProhibitNoAbortFunction

  " vint: -ProhibitNoAbortFunction
  function state.show_status(job, exit_status) dict abort
    if empty(self.status_type)
      return
    endif

    let prefix = '[' . self.status_type . '] '
    if a:exit_status == 0
      call swift#echo#EchoSuccess(prefix . "SUCCESS")
    else
      call swift#echo#EchoError(prefix . "FAIL")
    endif
  endfunction
  " vint: +ProhibitNoAbortFunction

  " vint: -ProhibitNoAbortFunction
  function state.show_errors(job, exit_status, data) abort
    if self.list_type ==# '_'
      return
    endif

    let l:winid = win_getid(winnr())
    call win_gotoid(self.winid)

    if a:exit_status == 0 && len(a:data) == 0
      call swift#list#Clean(self.list_type)
      call win_gotoid(l:winid)
      return
    endif

    let out = join(self.messages, "\n")

    let l:cd = exists('*haslocaldir') && haslocaldir() ? 'lcd' : 'cd'
    try
      execute l:cd self.job_dir
      call swift#list#ParseFormat(self.list_type, self.errorformat, out, self.list_title)
      let errors = swift#list#Get(self.list_type)
    finally
      execute l:cd fnameescape(self.dir)
    endtry

    if empty(errors)
      if a:exit_status == 0
        call swift#list#Clean(self.list_type)
      else
        call swift#echo#EchoError([self.dir] + self.messages)
      endif
      call win_gotoid(l:winid)
      return
    endif

    if self.winid == l:winid
      call swift#list#Window(self.list_type, len(errors))
      if self.jump_to_error
        call swift#list#JumpToFirst(self.list_type)
      else
        call win_gotoid(l:winid)
      endif
    endif
  endfunction
  " vint: +ProhibitNoAbortFunction

  let callbacks.cwd = state.job_dir

  function! s:callback(chan, msg) dict abort
    call add(self.messages, a:msg)
  endfunction
  let callbacks.callback = function('s:callback', [], state)

  function! s:exit_cb(job, exit_status) dict abort
    let self.exit_status = a:exit_status
    let self.exited = 1

    call self.show_status(a:job, a:exit_status)

    if self.closed
      call self.complete(a:job, self.exit_status, self.messages)
    endif
  endfunction
  let callbacks.exit_cb = function('s:exit_cb', [], state)

  function! s:close_cb(ch) dict abort
    let self.closed = 1

    if self.exited
      let l:job = ch_getjob(a:ch)
      call self.complete(l:job, self.exit_status, self.messages)
    endif
  endfunction
  let callbacks.close_cb = function('s:close_cb', [], state)

  return callbacks
endfunction

function! s:start_job(cmd, options) abort
  let l:options = copy(a:options)

  " Verify that the working directory for the job actually exists. Return
  " early if the directory does not exist. This helps avoid errors when
  " working with plugins that use virtual files that don't actually exist on
  " the file system.
  if !isdirectory(l:options.cwd)
    return
  endif

  return job_start(a:cmd, l:options)
endfunction

function! s:autowrite() abort
  if &autowrite == 1 || &autowriteall == 1
    silent! wall
  else
    for l:nr in range(0, bufnr('$'))
      if buflisted(l:nr) && getbufvar(l:nr, '&modified')
        " Sleep one second to make sure people see the message. Otherwise it is
        " often immediacy overwritten by the async messages (which also don't
        " invoke the "hit ENTER" prompt).
        call swift#echo#EchoWarning('[No write since last change]')
        sleep 1
        return
      endif
    endfor
  endif
endfunction

" vim: sw=2 ts=2 et
