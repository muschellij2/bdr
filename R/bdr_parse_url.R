#' BDR Parse JSON URL
#'
#' @param url A character URL pointing to a JSON output
#'
#' @return A list of the request and a
#' \code{list} of content.
#' @export
#'
#' @importFrom httr content GET
#' @importFrom tibble tibble as_tibble
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr %>% mutate
#'
#' @examples
#' library(dplyr)
#' df =bdr_collections()
#' df
#' url = df %>%
#'     filter(grepl("Bactrian ", name)) %>%
#'     pull(json_uri)
#' res = bdr_parse_url(url)
#' res$data
bdr_parse_url = function(url) {

  description = NULL
  rm(list = "description")
  res = httr::GET(url)
  cr = httr::content(res, as = "text")
  cr = jsonlite::fromJSON(cr, flatten = TRUE)
  classes = sapply(cr, class)
  if ("collections" %in% names(cr)) {
    cr = cr$collections
  }
  L = list(request = res,
           data = cr)
  return(L)
}
