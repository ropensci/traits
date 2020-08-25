# metacoder

<details>

* Version: 0.3.4
* Source code: https://github.com/cran/metacoder
* URL: https://grunwaldlab.github.io/metacoder_documentation/
* BugReports: https://github.com/grunwaldlab/metacoder/issues
* Date/Publication: 2020-04-29 19:40:03 UTC
* Number of recursive dependencies: 150

Run `revdep_details(,"metacoder")` for more info

</details>

## In both

*   checking whether package ‘metacoder’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/sckott/github/ropensci/traits/revdep/checks.noindex/metacoder/new/metacoder.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘metacoder’ ...
** package ‘metacoder’ successfully unpacked and MD5 sums checked
** using staged installation
** libs
clang++ -mmacosx-version-min=10.13 -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I'/Users/sckott/github/ropensci/traits/revdep/library.noindex/metacoder/Rcpp/include' -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include   -fPIC  -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -c RcppExports.cpp -o RcppExports.o
clang++ -mmacosx-version-min=10.13 -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I'/Users/sckott/github/ropensci/traits/revdep/library.noindex/metacoder/Rcpp/include' -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include   -fPIC  -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -c repel_boxes.cpp -o repel_boxes.o
clang++ -mmacosx-version-min=10.13 -std=gnu++11 -dynamiclib -Wl,-headerpad_max_install_names -undefined dynamic_lookup -single_module -multiply_defined suppress -Wl,-rpath,/Library/Frameworks/R.framework/Resources/lib /Library/Frameworks/R.framework/Resources/lib/libc++abi.1.dylib -L/Library/Frameworks/R.framework/Resources/lib -L/usr/local/lib -o metacoder.so RcppExports.o repel_boxes.o -F/Library/Frameworks/R.framework/.. -framework R -Wl,-framework -Wl,CoreFoundation
clang-7: error: no such file or directory: '/Library/Frameworks/R.framework/Resources/lib/libc++abi.1.dylib'
make: *** [metacoder.so] Error 1
ERROR: compilation failed for package ‘metacoder’
* removing ‘/Users/sckott/github/ropensci/traits/revdep/checks.noindex/metacoder/new/metacoder.Rcheck/metacoder’

```
### CRAN

```
* installing *source* package ‘metacoder’ ...
** package ‘metacoder’ successfully unpacked and MD5 sums checked
** using staged installation
** libs
clang++ -mmacosx-version-min=10.13 -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I'/Users/sckott/github/ropensci/traits/revdep/library.noindex/metacoder/Rcpp/include' -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include   -fPIC  -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -c RcppExports.cpp -o RcppExports.o
clang++ -mmacosx-version-min=10.13 -std=gnu++11 -I"/Library/Frameworks/R.framework/Resources/include" -DNDEBUG  -I'/Users/sckott/github/ropensci/traits/revdep/library.noindex/metacoder/Rcpp/include' -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -I/usr/local/include   -fPIC  -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -c repel_boxes.cpp -o repel_boxes.o
clang++ -mmacosx-version-min=10.13 -std=gnu++11 -dynamiclib -Wl,-headerpad_max_install_names -undefined dynamic_lookup -single_module -multiply_defined suppress -Wl,-rpath,/Library/Frameworks/R.framework/Resources/lib /Library/Frameworks/R.framework/Resources/lib/libc++abi.1.dylib -L/Library/Frameworks/R.framework/Resources/lib -L/usr/local/lib -o metacoder.so RcppExports.o repel_boxes.o -F/Library/Frameworks/R.framework/.. -framework R -Wl,-framework -Wl,CoreFoundation
clang-7: error: no such file or directory: '/Library/Frameworks/R.framework/Resources/lib/libc++abi.1.dylib'
make: *** [metacoder.so] Error 1
ERROR: compilation failed for package ‘metacoder’
* removing ‘/Users/sckott/github/ropensci/traits/revdep/checks.noindex/metacoder/old/metacoder.Rcheck/metacoder’

```
