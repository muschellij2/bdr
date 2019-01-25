#' Parse BDR Collection
#'
#' @return A \code{tibble} of information of collections
#' @export
#'
#' @examples
#' library(dplyr)
#' df = bdr_collections()
#' df
#' url = df %>%
#'     filter(grepl("Bactrian ", name)) %>%
#'     pull(json_uri)
#' coll = bdr_collection(url)
#' testthat::expect_is(coll, "tbl")
#' item_urls =coll$items[[1]]$json_uri
#'
bdr_collection = function(url) {

  res = bdr_parse_url(url)
  cr = res$data

  cr$tags = paste(cr$tags, collapse = "; ")
  if (is.list(cr)) {
    cr = lapply(cr, function(x) {
      if (length(x) == 0) {
        x = NA
      }
      x
    })
    cr$num_items = cr$items$numFound
    cr$item_start = cr$items$start
    cr$items$numFound = cr$items$start = NULL
    cr$items = cr$items$docs
    cr$items = list(cr$items)
    cr$facets = list(cr$facets)

    atomic = sapply(cr, is.atomic)
    not_atomic_classes = sapply(cr[!atomic], class)
    if (!all(not_atomic_classes %in% c("data.frame", "list"))) {
      warning("Cannot make into table, returning list")
      return(cr)
    }

    cr = tibble::as_tibble(cr)
  }

  df = cr %>%
    mutate(
      description = gsub("<(|/)br(|/)>", "\n", description),
      description = gsub("\r", "\n", description),
      description = gsub("<(|/)(P|p)>", " ", description),
      description = gsub("<(|/)(strong|b|em)>", " ", description),
      description = gsub("<(|/)i>", " ", description),
      description = gsub("<(|/)li>", " ", description),
      description = gsub("<(|/)ul>", " ", description),
      description = sub_ascii(description),
      description = sub_space(description),
      description = gsub("\n", " ", description),
      description = trimws(description))
  df$tags = sapply(df$tags, paste, collapse = "; ")
  df$tags[ df$tags %in% "" ] = NA
  L = list(request = res$request,
           data = df)

  return(df)
}
