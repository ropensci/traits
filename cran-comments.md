R CMD CHECK passed on my local OS X install with R 3.2.4 and
R development version, Ubuntu running on Travis-CI, and Windows
R 3.2.4 and devel on a virtualbox Windows install.

This submission fixes some bugs and adds some new features as
outlined in the NEWS file.

I had to submit with dev R since current stable wasn't working with 
devtools::release() - was giving me the error: "No suitable 
spell-checker program found"

This is a re-submission of a previous submission that changes a 
CRAN package URL in the README to it's canonical form.

Thanks! 
Scott Chamberlain
