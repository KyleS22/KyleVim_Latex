" Make sure this plugin is runnable

let g:kyle_vim_latex_version = "0.1.0"

if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif


filetype plugin on

let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>p')), ':h')

"prevent vim from thinking some latex files are plaintex
let g:tex_flavor = "latex"

" Tex
autocmd bufnewfile *.tex so ~/.vim/header_templates/tex_header.txt"
autocmd bufnewfile *.tex exe "1," . 6 . "g/File Name:.*/s//File Name: " .expand("%:t")
autocmd bufnewfile *.tex exe "1," . 6 . "g/Date:.*/s//Date: " .strftime("%d-%m-%Y")

" Syntax highlighting for math zones
au FileType tex syn region texMathZoneZ matchgroup=texStatement start="\$" matchgroup=texStatement end="\$" contains=@texMathZoneGroup


