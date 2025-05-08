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
clean_temp:
	@echo "�� Cleaning up auxiliary files..."
	find . -maxdepth 1 -type f ! \( -name "*.tex" -o -name "*.html" -o -name "*.pdf" -o -name "*.docx" \) -exec rm -f {} +

clean: clean_temp
	@echo "�� Cleaning all files..."
	rm -f $(HTMLFILE)
	rm -f $(PDFFILE)
	rm -f $(DOCXFILE)