
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bdr

<!-- badges: start -->

<!-- badges: end -->

The goal of bdr is to provide a simple interface to interact with the
‘RESTful’ API of the Brown Digital Repository API
<https://repository.library.brown.edu/studio/api-docs/>.

## Installation

You can install the released version of bdr from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("bdr")
```

## Example

We will use the `bdr_collections` function to grab the collections from
BDR:

``` r
library(bdr)
df = bdr_collections()
head(df)
#> # A tibble: 6 x 7
#>      id description     name    json_uri    tags  uri      thumbnail_url   
#>   <int> <chr>           <chr>   <chr>       <chr> <chr>    <chr>           
#> 1   674 Located in the… Africa… https://re… <NA>  https:/… <NA>            
#> 2   278 "The Departmen… Americ… https://re… <NA>  https:/… <NA>            
#> 3   785 This is the re… Angela… https://re… depo… https:/… https://reposit…
#> 4   280 The Department… Anthro… https://re… <NA>  https:/… <NA>            
#> 5   282 The Division o… Applie… https://re… <NA>  https:/… <NA>            
#> 6   719 "This case stu… Bactri… https://re… rese… https:/… https://reposit…
```

Once we have the collections, we can grab a particular collection using
standard `dplyr` syntax to grab the collection you want to explore using
the `bdr_collection` function:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
coll_url = df %>%
    filter(grepl("Bactrian ", name)) %>%
    pull(json_uri)
coll = bdr_collection(coll_url)
coll
#> # A tibble: 1 x 14
#>      id description name  json_uri tags  thumbnail_url uri   facets
#>   <int> <chr>       <chr> <chr>    <chr> <chr>         <chr> <list>
#> 1   719 "This case… Bact… https:/… rese… https://repo… http… <data…
#> # … with 6 more variables: parent_folders <lgl>, child_folders <lgl>,
#> #   ancestors <lgl>, items <list>, num_items <int>, item_start <int>
```

We can extract the `item` URL from `coll$items`:

``` r
url = coll$items[[1]]$json_uri[1]
print(url)
#> [1] "https://repository.library.brown.edu/api/items/bdr:697231/"
```

The `bdr_item_download_link` function will process links to get the
download link for downloading the item:

``` r
link = bdr_item_download_link(url)
```

We can use `httr::GET` to download the data to disk and unzip them using
the `unzip` function:

``` r

tfile = tempfile(fileext = ".zip")
dl = httr::GET(link,
               httr::write_disk(tfile),
               if (interactive()) httr::progress())
tdir = tempfile()
dir.create(tdir)
unz = unzip(tfile, exdir = tdir)
#> Warning in unzip(tfile, exdir = tdir): error -3 in extracting from zip file
```
