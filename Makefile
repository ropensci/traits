all: move rmd2md

move:
		cp inst/vign/betydb.md vignettes;\
		cp inst/vign/traits.md vignettes

rmd2md:
		cd vignettes;\
		mv betydb.md betydb.Rmd;\
		mv traits.md traits.Rmd
