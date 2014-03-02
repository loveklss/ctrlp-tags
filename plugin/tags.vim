
" Create a command to directly call the new search type
command! -nargs=? CtrlPTags call ctrlp#tags#tags(<q-args>)

nnoremap <Leader>fp :CtrlPTags<cr>
" Initialise list by a word under cursor
nnoremap <Leader>fd :execute 'CtrlPTags ' . expand('<cword>')<cr>
