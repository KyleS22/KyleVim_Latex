" Make sure this plugin is runnable

let g:kyle_vim_latex_version = "0.1.0"

if !has("python3")
	echo "Vim must be compiled with +python3 to use KyleVim"
	finish
endif


filetype plugin on

let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>p')), ':h')


