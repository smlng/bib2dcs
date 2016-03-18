# bib2dcs
BibTeX to Document Control Sheet

## Requirements

To runs this tool chain you need _Perl_ and the `Text::BibTeX` package for Perl.
Typically you can easily install it using _CPAN_:
```
cpan -i Text::BibTeX
```

You further require _BibTool_ a very helpful tool when working with _BibTeX_.
Use your local package manager to install it or look [here](http://www.gerd-neugebauer.de/software/TeX/BibTool/).

You also need _LuaLaTeX_ to compile and create the PDF output.

## Usage

First compile your original LaTeX document, in this case your final project
report. This contains references of your publications for which you want to
create the _document control sheet_  aka "Berichtsblatt" in German. Thus, you
should have some _bbl_ file after LaTeX+BibTeX compilation is done, this file
is primary input to our tool chain. Further we need the path to your BibTeX
database (bib files) and the name(s) of the files.

```
export BIBINPUT=/path/to/BIBFILES
export BIBFILES="name1 [name2 [name3 [...]]]"
cd src
./get_bibitems.sh /path/to/report.bbl > input.bib
perl bib2csv.pl input.bib > input.csv
lualatex berichtsblatt.tex
lualatex berichtsblatt.tex
```

This will generate `berichtsblatt.pdf` containing all publications.
