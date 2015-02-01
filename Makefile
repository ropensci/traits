all: move rmd2md

move:
		cp inst/vign/betydb.md vignettes

rmd2md:
		cd vignettes;\
		mv betydb.md betydb.Rmd
