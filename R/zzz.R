mssg <- function(v, ...) if(v) message(...)

try_default <- function (expr, default, quiet = FALSE){
    result <- default
    if (quiet) {
        tryCatch(result <- expr, error = function(e) {
        })
    }
    else {
        try(result <- expr)
    }
    result
}

failwith <- function (default = NULL, f, quiet = FALSE){
    f <- match.fun(f)
    function(...) try_default(f(...), default, quiet = quiet)
}

traits_capwords <- function(s, strict = FALSE, onlyfirst = FALSE) {
  cap <- function(s) paste(toupper(substring(s,1,1)),
{s <- substring(s,2); if(strict) tolower(s) else s}, sep="", collapse=" " )
if(!onlyfirst){
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
} else
{
  sapply(s, function(x)
    paste(toupper(substring(x,1,1)),
          tolower(substring(x,2)),
          sep="", collapse=" "), USE.NAMES=F)
}
}

traitsc <- function (l) Filter(Negate(is.null), l)

strmatch <- function(x, y) regmatches(x, regexpr(y, x))

tryfail <- function (default = NULL, f, ..., quiet = FALSE){
  f <- match.fun(f)
  function(...) trydefault(f(...), default, quiet = quiet)
}

trydefault <- function (expr, default, quiet = FALSE){
  result <- default
  if (quiet) {
    tryCatch(result <- expr, error = function(e) {
    })
  }
  else {
    try(result <- expr)
  }
  result
}

low_names <- function(x) {
  if (inherits(x, "data.frame")) {
    stats::setNames(x, tolower(names(x)))
  } else {
    x
  }
}

df_null <- function(x) {
  data.frame(
    Filter(function(z) !is.null(z), x),
    stringsAsFactors = FALSE
  )
}

dtread <- function(x) {
  tibble::as_tibble(
    data.table::fread(x, stringsAsFactors = FALSE, data.table = FALSE)
  )
}
