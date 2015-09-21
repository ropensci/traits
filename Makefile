all: move rmd2md

move:
		cp inst/vign/betydb.md vignettes;\
		cp inst/vign/traits_intro.md vignettes

rmd2md:
		cd vignettes;\
		mv betydb.md betydb.Rmd;\
		mv traits_intro.md traits_intro.Rmd
