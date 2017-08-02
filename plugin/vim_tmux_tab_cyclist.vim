" if exists("g:loaded_vim_tmux_buffet") || &cp || v:version < 700
"   finish
" endif
"
" let g:loaded_vim_tmux_buffet = 1

function! s:UseTmuxBuffetMappings()
  return !exists("g:vim_tmux_buffet_no_mappings") || !g:vim_tmux_buffet_no_mappings
endfunction

"From https://github.com/christoomey/vim-tmux-navigator

function! s:TmuxOrTmateExecutable()
  if s:StrippedSystemCall("[[ $TMUX == *'tmate'* ]] && echo 'tmate'") == 'tmate'
    return "tmate"
  else
    return "tmux"
  endif
endfunction

function! s:StrippedSystemCall(system_cmd)
  let raw_result = system(a:system_cmd)
  return substitute(raw_result, '^\s*\(.\{-}\)\s*\n\?$', '\1', '')
endfunction

function! s:InTmuxSession()
  return $TMUX != ''
endfunction

function! s:TmuxSocket()
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = s:TmuxOrTmateExecutable() . ' -S ' . s:TmuxSocket() . ' ' . a:args
  return system(string(cmd))
endfunction

"end from https://github.com/christoomey/vim-tmux-navigator

function! s:RegisterToTmux(reg)
        let args = 'set-buffer "' . a:reg . '"'
        silent call s:TmuxCommand(args)
endfunction

function! s:TmuxCopyToUnnamed()
        let args = "show-buffer"
        let @" = s:TmuxCommand(args)
endfunction

command! TmuxBuffetRegisterToTmux call <SID>RegisterToTmux(@")
command! TmuxBuffetCopyToUnnamed call <SID>TmuxCopyToUnnamed()

if s:UseTmuxBuffetMappings()
        noremap <silent> <leader>t :TmuxBuffetRegisterToTmux<CR>
        noremap <silent> <leader>T :TmuxBuffetCopyToUnnamed<CR>
endif
