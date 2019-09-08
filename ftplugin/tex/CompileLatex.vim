
""map <F2> :!pdflatex % && bibtex %:r && pdflatex % && pdflatex % && xdg-open %:r.pdf
map <F2> :call CompileLatex()<CR>


"Determine if the current file needs bibtex
function! IsBibtex()
	
	let save_cursor = getcurpos()
	
	call cursor(0, 0)

	let search_result = search("bibliography{", "c")

	call setpos('.', save_cursor)
	
	return search_result ? 1 : 0

endfunction


" Check for bibtex if the file is a presentation
function! IsBibPresentation()
	let save_cursor = getcurpos()
	
	call cursor(0, 0)

	let search_result = search("bibitem{", "c")

	call setpos('.', save_cursor)

	return search_result ? 1 : 0


endfunction

" If this is a multi-file project, check the main.tex file for bibtex
function! IsMainBibtex()
	if filereadable("main.tex")
		let search_result = system("grep bibliography main.tex")
		echo search_result

		if empty(search_result)
			return 0
		else 
			return 1
		endif
	 
	endif


endfunction

" Compile the latex project
function! CompileLatex()
	
	write
	
	if CheckMainTexExists()	
		if IsMainBibtex()
			:!pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex && xdg-open main.pdf 2>/dev/null
		else
			:!pdflatex main.tex && xdg-open main.pdf 2>/dev/null
		endif

	else

		if IsBibtex() || IsBibPresentation()
			:!pdflatex % && bibtex %:r && pdflatex % && pdflatex % && xdg-open %:r.pdf 2>/dev/null
		else
			:!pdflatex % && xdg-open %:r.pdf 2>/dev/null
		endif
	endif


endfunction

" See if this is a multi-file project
function! CheckMainTexExists()
	if filereadable("main.tex")
		return 1
	else
		return 0
	endif
endfunction


