" Make sure this plugin is runnable


if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif

if exists('g:KyleVim_Latex_plugin_loaded')
	finish
endif


let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>p')), ':h')

filetype plugin on

"-----------------------------------------------
" Settings
"-----------------------------------------------

"Set syntax highlighting for latex
set syntax=context

" Indents word-wrapped lines as much as the 'parent' line
set breakindent
set autoindent
set wrap linebreak

" Turn on spell check
set spell

" Set the highlighting for mispelled words
hi SpellBad cterm=underline,bold ctermfg=red

set spellfile+=projectspellfile.utf-8.add

" Go back to last misspelled word and pick first suggestion.
inoremap <C-L> <C-G>u<Esc>[s1z=`]a<C-G>u

" Select last misspelled word (typing will edit).
nnoremap <C-K> <Esc>[sve<C-G>
inoremap <C-K> <Esc>[sve<C-G>
snoremap <C-K> <Esc>b[sviw<C-G>

if !exists('g:KyleVimLatexBibtexFile')
	let g:KyleVimLatexBibtexFile = "refs.bib"
endif

"-----------------------------------

"
"-----------------------------------------------
" Key Maps
"----------------------------------------------

" put \begin{} \end{} tags tags around the current word
noremap  <C-B>      YpkI\begin{<ESC>A}<ESC>jI\end{<ESC>A}<esc>kA
noremap! <C-B> <ESC>YpkI\begin{<ESC>A}<ESC>jI\end{<ESC>A}<esc>kA

" Same as above
map \gq ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>gq//-1<CR>
map lp ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>//-1<CR>.<CR>

" Allow better movement across lines
noremap j gj
noremap k gk
noremap gj j
noremap gk k

noremap <Down> gj
noremap <Up> gk


"---------------------------------------------
" Autocompletes
"---------------------------------------------

" Math mode autocomplete
inoremap $	$$<Left>
inoremap $<CR>	$<CR>$<Esc>O
inoremap $$	$

" Call the CR() function
inoremap <expr><buffer> <CR> CR()

inoremap <expr> \cite SwitchRefsCompletion(1)

"----------------------------------------------
" Functions
"---------------------------------------------

" What to do when we hit enter
function! CR()
	" See if we are in a list environment, and add the \item tag if so
	if searchpair('\\begin{itemize}', '', '\\end{itemize}', '')
		return "\r\\item"
	endif

    call SwitchRefsCompletion(0)

    return "\r"
endfunction



" Enable autocomplete of bib tags when using the \cite{} command
function! EnableBibtexAutocomplete()
	python3 sys.argv = [vim.eval('getcwd()')]
	python3 bibtex_autocomplete.autocomplete_bibtex(sys.argv[0])
endfunction

" Remove the bib keys file
function! CleanUpBibtexTagsFile()
    python3 bibtex_autocomplete.clean_up_autocomplete_file()
endfunction

" Switch the autocomplete file to be the bib keys file
function SwitchRefsCompletion(enabled)
        
        if CheckBibRefsExists()
                
                if a:enabled
                        exe 'set cpt=k.kyle_vim_latex_bibtex_file.txt'
                        return "\\cite"
                else
                        exe 'set cpt=.,w,b,u,t,i'
                        return ""
                endif
                
        endif

        return ""

endfunction

" See if a refs.bib file exists in the project
function! CheckBibRefsExists()
        if filereadable(g:KyleVimLatexBibtexFile)
                return 1
        else
                return 0
        endif
endfunction

"------------------------------------------------------------
" Autocommands
" -----------------------------------------------------------
autocmd VimEnter *.tex call EnableBibtexAutocomplete()
autocmd VimLeave *.tex call CleanUpBibtexTagsFile()
autocmd BufNewFile,BufRead *.tex :syntax spell toplevel

"---------------------------------------------------------
" Load the python modules
python3 << EOF

import sys
from os.path import normpath, join
import vim


plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '../..', 'python'))
sys.path.insert(0, python_root_dir)

import bibtex_autocomplete
EOF




let g:KyleVim_Latex_plugin_loaded = 1
