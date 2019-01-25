#' BDR Collections
#'
#' @return A \code{tibble} of information of collections
#' @export
#'
#' @examples
#' library(dplyr)
#' df =bdr_collections()
#' df
#' uri = df %>%
#'     filter(grepl("Bactrian ", name)) %>%
#'     pull(json_uri)
bdr_collections = function() {

  description = NULL
  rm(list = "description")
  url = "https://repository.library.brown.edu/api/collections/"
  res = bdr_parse_url(url)
  cr = res$data

  cr = tibble::as_tibble(cr)

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
  L = list(request = res,
           data = df)

  return(df)
}
