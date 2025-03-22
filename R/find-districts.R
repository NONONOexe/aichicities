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
  res <- stringr::str_like(
    aichicities::aichi_districts$city,
    paste0(".*", city_name, ".*")
  )
  if (any(res)) {
    return(aichi_districts[res, ])
  }

  res <- stringr::str_like(
    aichicities::aichi_districts$city_kanji,
    paste0(".*", city_name, ".*")
  )
  if (any(res)) {
    return(aichi_districts[res, ])
  }

  cli::cli_alert_info("There was no district with the specified name: {city_name}")
  return(NULL)
}
