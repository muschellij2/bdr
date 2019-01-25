#' Parse BDR Item Downlaod Link
#'
#' @return A \code{character} vector of links.
#' @export
#'
#' @examples
#' library(dplyr)
#' df = bdr_collections()
#' df
#' coll_url = df %>%
#'     filter(grepl("Bactrian ", name)) %>%
#'     pull(json_uri)
#' coll = bdr_collection(coll_url)
#' testthat::expect_is(coll, "tbl")
#' url =coll$items[[1]]$json_uri[1]
#' link = bdr_item_download_link(url)
#' tfile = tempfile(fileext = ".zip")
#' dl = httr::GET(link,
#' httr::write_disk(tfile),
#' if (interactive()) httr::progress())
#' tdir = tempfile()
#' dir.create(tdir)
#' unz = unzip(tfile, exdir = tdir)
#'
bdr_item_download_link = function(url) {

  res = bdr_parse_url(url)
  cr = res$data

  link = cr$primary_download_link
  add_download = !grepl("download(|/)$", link)
  if (any(add_download)) {
    link[add_download] = sub("/$", "", link[add_download])
    link[add_download] = paste0(link[add_download], "/download")
  }
  link = sub("contents/download", "download", link)
  return(link)
}
