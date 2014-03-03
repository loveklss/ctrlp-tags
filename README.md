ctrlp-tags
==========

a ctrlp plugin to search tags of current file.
I had use anoter ctrlp plugin 'ctrlp-funky'.
but it can't search variable, and it may miss some functin define,
I read it's code, and find it's very simple to write a ctrlp plugin,
so I write this plugin.

install
==========

first you need to install ctags and ctrlp,
I use ctags to get the tags of current file,
and use ctrlp to show and search the result;
if you use vundle to manager your plugin,
you can add a line into your .vimrc:

	Bundle 'konkashaoqiu/ctrlp-tags.git'
	Bundle 'konkashaoqiu/vim-tools.git'

the vim-tools include some functions,
ctrlp-tags depend on them,so you need to install it.

useage
==========

add a line to your .vimrc:

	let g:ctrlp_extensions = ['tags']

now you can use a command to start ctrlp-ctags:

	:CtrlPTags or :CtrlPTags keyword

I think it's better to add two keymaps into your .vimrc:

	nnoremap <Leader>ff :CtrlPTags<cr>
	nnoremap <Leader>fd :execute 'CtrlPTags ' . expand('<cword>')<cr>

note
==========

I just test on linux, so it may be not work on windows.


