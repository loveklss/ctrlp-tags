ctrlp-tags
==========

a ctrlp plugin to search tags of current file

install
==========

first you need to install ctags and ctrlp,
I use ctags to get the tags of current file,
and use ctrlp to show and search the result;
if you use vundle to manager your plugin,
you can add a line into your .vimrc:

	Bundle 'konkashaoqiu/ctrlp-tags.git'


useage
==========

add a line to your .vimrc:
	let g:ctrlp_extensions = ['tags']

now you can use a command to start ctrlp-ctags:
	:CtrlPTags or :CtrlPTags keyword

I think it's better to add to keymap into your .vimrc:
	nnoremap <Leader>ff :CtrlPTags<cr>
	nnoremap <Leader>fd :execute 'CtrlPTags ' . expand('<cword>')<cr>

note
==========

I just test on linux, so it may be not work on windows,


