" Keymaps
let mapleader = " "
nnoremap <Leader>r :source ~/.vimrc<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :qa!<CR>

set relativenumber
set number
syntax on

" Set your preferred colorscheme
colorscheme wildcharm

" Make background transparent
if &term =~ 'alacritty\|xterm\|rxvt\|linux'
  hi Normal ctermbg=none
  hi NonText ctermbg=none
else
  hi Normal guibg=none
  hi NonText guibg=none
endif

" Default explorer configs
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_banner = 1
let g:netrw_browse_split = 4
let g:netrw_liststyle = 3
let g:netrw_winsize = 27

" Function for explorer
function! ToggleExplorer()
  if exists("t:netrw_buf") && bufwinnr(t:netrw_buf) != -1
    exe bufwinnr(t:netrw_buf) . "close"
  else
    Lexplore
    let t:netrw_buf = bufnr()
  endif
endfunction

nnoremap <Leader>e :call ToggleExplorer()<CR>
