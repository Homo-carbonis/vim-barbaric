" Check dependencies
if has('mac') && executable('xkbswitch')
  let g:barbaric_ime = 'macos'
elseif filereadable('/usr/lib/libxkbswitch.so')
  let g:XkbSwitchLib = "/usr/lib/libxkbswitch.so"
  let g:barbaric_ime = 'xkb-switch'
elseif filereadable('/lib/libxkbswitch.so')
  let g:XkbSwitchLib = "/lib/libxkbswitch.so"
  let g:barbaric_ime = 'xkb-switch'
elseif executable('fcitx-remote') && system('fcitx-remote') > 0
  let g:barbaric_ime = 'fcitx'
elseif executable('ibus')
  let g:barbaric_ime = 'ibus'
else
  finish
endif

" The input method for Normal mode (as defined by `xkbswitch -g` or `ibus engine`)
if !exists('g:barbaric_default')
  if g:barbaric_ime == 'fcitx'
    let g:barbaric_default = '-c'
  else
    let g:barbaric_default = barbaric#get_im()
  endif
endif

" The scope where alternate input methods persist (buffer, window, tab, global)
if !exists('g:barbaric_scope')
  let g:barbaric_scope = 'buffer'
endif

" Forget alternate input method after n seconds in Normal mode (disabled by default)
" Useful if you only need IM persistence for short bursts of active work.
if !exists('g:barbaric_timeout')
  let g:barbaric_timeout = -1
endif

augroup barbaric
  autocmd!
  autocmd InsertEnter * call barbaric#switch('insert')
  autocmd InsertLeave * call barbaric#switch('normal')
  autocmd FocusGained * call barbaric#switch('focus')
  autocmd FocusLost   * call barbaric#switch('unfocus')
  autocmd VimLeave    * call barbaric#switch('unfocus')
  autocmd VimEnter    * call barbaric#switch('normal')
augroup END
