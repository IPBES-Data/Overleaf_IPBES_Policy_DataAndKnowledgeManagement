BASENAME = IPBES_Data_and_Knowledge_Management_Policy_ver2.1

TEXFILE = $(BASENAME).tex
TEXSOURCES = $(wildcard *.tex)
PDFFILE = $(BASENAME).pdf
HTMLFILE = $(BASENAME).html
DOCXFILE = $(BASENAME).docx

.PHONY: all clean clean_tmp

all: clean pdf html docx

# PDF target builds if any .tex file changes
pdf: $(PDFFILE)
$(PDFFILE): $(TEXSOURCES)
	@echo "�� Building PDF with glossary..."
	pdflatex -interaction=nonstopmode -file-line-error -synctex=1 $(TEXFILE)
	makeglossaries $(BASENAME).glo
	pdflatex -interaction=nonstopmode -file-line-error -synctex=1 $(TEXFILE)
	pdflatex -interaction=nonstopmode -file-line-error -synctex=1 $(TEXFILE)

# HTML builds only if PDF changes
html: $(HTMLFILE)
$(HTMLFILE): $(PDFFILE)
	@echo "�� Generating HTML (3-pass htlatex)..."
	htlatex $(TEXFILE) "xhtml,charset=utf-8" " -cunihtf -utf8"
	htlatex $(TEXFILE) "xhtml,charset=utf-8" " -cunihtf -utf8"
	htlatex $(TEXFILE) "xhtml,charset=utf-8" " -cunihtf -utf8"

# DOCX builds only if HTML changes
docx: $(DOCXFILE)
$(DOCXFILE): $(HTMLFILE)
	@echo "�� Converting HTML to DOCX..."
	pandoc $(HTMLFILE) -o $(DOCXFILE)
	@echo "✅ Conversion complete: $(DOCXFILE)"

# Clean rules stay phony
clean_tmp:
	@echo "�� Cleaning up auxiliary files..."
	rm -f $(BASENAME).{aux,log,glo,gls,glg,idx,ilg,ind,dvi,idv,tmp,4tc,css,xref,lg,ist,4ct,tdo,toc}
	rm -f $(HTMLFILE).aux $(BASENAME).out
	rm -f $(BASENAME)[0-9]*.svg
	rm -f $(BASENAME)[0-9]*.html

clean: clean_tmp
	@echo "�� Cleaning all files..."
	rm -f $(HTMLFILE)
	rm -f $(PDFFILE)
	rm -f $(DOCXFILE)