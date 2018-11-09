#
# Copyright (C) 2012 by Alex Hirzel
#
# This file may be distributed and/or modified under the
# conditions of the LaTeX Project Public License, either
# version 1.2 of this license or (at your option) any later
# version. The latest version of this license is in:
#
#    http://www.latex-project.org/lppl.txt
#
# and version 1.2 or later is part of all distributions of
# LaTeX version 1999/12/01 or later.
#

CLASS   = tikzpub
FIGURES = examplebusinesscard.pdf testbusinesscard.pdf

PDFLATEX  = pdflatex -interaction=batchmode
MAKEINDEX = makeindex

LATEX=texfot -ignore '^This is \\w*TeX|^Output written on ' -no-stderr latexmk -pdfxe -xelatex -halt-on-error

default: ${CLASS}.cls ${CLASS}.pdf

# Running the .ins creates the figure sources (.tex) and the .cls from the .dtx
${CLASS}.cls ${FIGURES:.pdf=.tex}: ${CLASS}.ins ${CLASS}.dtx
	${PDFLATEX} $<

# Compile each figure (.tex -> .pdf) using the .cls
%.pdf: %.tex ${CLASS}.cls
	${LATEX} $<

# Documentation requires figures (.tex and .pdf) and .dtx
${CLASS}.pdf: ${CLASS}.dtx ${FIGURES}
	${PDFLATEX} ${CLASS}.dtx
	${PDFLATEX} ${CLASS}.dtx
	${MAKEINDEX} -s gglo.ist -o ${CLASS}.gls ${CLASS}.glo
	${MAKEINDEX} -s gind.ist ${CLASS}.idx
	${PDFLATEX} ${CLASS}.dtx
	${PDFLATEX} ${CLASS}.dtx
	make tidy

tidy:
	rm -f $(foreach ext, aux glo gls idx ilg ind log out toc, \
	          ${CLASS}.${ext} ${FIGURES:.pdf=.${ext}})

clean:
	make tidy
	rm -f ${FIGURES} ${FIGURES:.pdf=.tex} ${CLASS}.cls ${CLASS}.pdf

.PHONY: default tidy clean

