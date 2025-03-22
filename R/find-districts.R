#' Find district by city name
#'
#' @description
#' The function returns the districts of the specified city name.
#' The search is performed with partial matches.
#'
#' @param city_name Part of the city name
#' @return districts of the specified city name
#' @export
#' @examples
#' \dontrun{
#' toyota_districts <- find_districts("Toyota-shi")
#' }
find_districts <- function(city_name) {
  data("aichi_districts", package = "aichicities", envir = environment())
  pattern <- paste0(".*", city_name, ".*")

  matches_city_name <- purrr::map(
    pattern,
    stringr::str_like,
    string = aichi_districts$city
  )
  matches_city_kanji <- purrr::map(
    pattern,
    stringr::str_like,
    string = aichi_districts$city_kanji
  )

  matches_districts <- c(matches_city_name, matches_city_kanji) %>%
    purrr::reduce(`|`)

  if (!any(matches_districts)) {
    cli::cli_alert_info("There was no district with the specified name: {city_name}")
    return(NULL)
  }

  return(aichi_districts[matches_districts, ])
}
