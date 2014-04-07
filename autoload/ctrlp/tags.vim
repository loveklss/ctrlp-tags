
if exists("g:loaded_ctrlp_tags") || &cp
	finish
endif
let g:loaded_ctrlp_tags = 1

scriptencoding utf-8

" Add this extension's settings to g:ctrlp_ext_vars
"
" Required:
"
" + init: the name of the input function including the brackets and any arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
" + specinput: enable special inputs '..' and '@cd' (disabled by default)
"
" I don't understand why enter function should be 'ctrlp#tags#enter()'
" but accept function should be 'ctrlp#tags#accept'
" one has '()', but another not
call add(g:ctrlp_ext_vars, {
			\ 'enter': 'ctrlp#tags#enter()',
			\ 'init': 'ctrlp#tags#init(s:crbufnr)',
			\ 'accept': 'ctrlp#tags#accept',
			\ 'lname': 'tags',
			\ 'sname': 'tags',
			\ 'type': 'tabs',
			\ })


function! ctrlp#tags#tags(word)
	call g:VimDebug('enter ctrlp#tags#tags')

	let s:winnr = winnr()
	if !empty(a:word)
		let default_input_save = get(g:, 'ctrlp_default_input', '')
		let g:ctrlp_default_input = a:word
	endif

	call ctrlp#init(ctrlp#tags#id())
	if exists('default_input_save')
		let g:ctrlp_default_input = default_input_save
	endif

endfunction

function! ctrlp#tags#enter()
	call g:VimDebug('enter ctrlp#tags#enter')

	let s:filepath = expand('%:p')
	call g:VimDebug('filepath is ' .s:filepath)
endfunction

" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#tags#init(bufnr)
	call g:VimDebug('enter ctrlp#tags#init')

	let s:bufnr = a:bufnr
	let s:filetype = getbufvar(a:bufnr, '&l:filetype')
	call g:VimDebug('filetype is ' .s:filetype)

	return s:getTags()
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#tags#accept(mode, str)
	call g:VimDebug('enter ctrlp#tags#accept')
	call ctrlp#exit()

	let pattern = get(split(a:str, "\t"), 1)
	let pattern = substitute(pattern, '\*', '\\*', 'g')
	call g:VimDebug("select: " .pattern)
	let lnum = search(pattern)
	call g:VimDebug("search line number = " .lnum)

    " Mark current position so it can be jumped back to
    mark '

	call setpos('.', [s:bufnr, lnum, 1, 0])
	call s:after_jump()
endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#tags#id()
	return s:id
endfunction

function! s:getTags()
	let s:tags = []
	let ctagsBin = s:getCtagsBin()
	let ctagsCmd = ctagsBin .' -f - ' .s:filepath
	call g:VimDebug('ctags cmd = ' .ctagsCmd)
	let ctagsOutput = system(ctagsCmd)
	call g:VimDebug(ctagsOutput)

	if ctagsOutput == -1
		call g:VimDebug('ctagsoutput is -1')
		return s:tags
	elseif ctagsOutput == ''
		call g:VimDebug('ctagsoutput is null')
		return tags
	endif

	let tag_list = split(ctagsOutput, '\n\+')
	for line in tag_list
		" skip comments
		if line =~# '^!_TAG_'
			continue
		endif

		let parts = split(line, '/^')
		let parts1 = get(parts, 0)
		let parts2 = get(parts, 1)
		let list1 = split(parts1, "\t")
		let list2 = split(parts2, "\t")
		if get(list2, 1) == "p"
			continue
		endif
		let name   = get(list1, 0)
		let define = g:StringTrim(get(list2, 0))
		let define = substitute(define, '$/;"', '', '')
		let type   = g:StringTrim(get(list2, 1))
		let line     = name ."\t" .define ."\t" .type
		call add(s:tags, line)
	endfor
	return s:tags
endfunction

function! s:getCtagsBin()
	if has('win32') || has('win64') || has('win32unix')
		return 'ctags.exe'
	else 
		return 'ctags'
	endif
endfunction

function! s:after_jump()
	silent! execute 'normal! zxzz'
endfunction
