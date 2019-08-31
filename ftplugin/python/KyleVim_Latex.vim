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


" TODO: Remove this and replace with vimscript functions to call python
" functionality
"
" Load the python modules
python3 << EOF

import sys
from os.path import normpath, join
import vim

plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '../..', 'python'))
sys.path.insert(0, python_root_dir)

EOF


let g:KyleVim_Latex_plugin_loaded = 1
