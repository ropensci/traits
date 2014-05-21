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
