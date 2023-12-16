globalVariables("aichi_districts")

#' Aichi prefecture administrative district data
#'
#' Information on administrative areas such as cities and wards
#' in Aichi prefecture.
#'
#' @format Each is a tibble with 69 rows 6 variables:
#' \describe{
#' \item{city}{City names}
#' \item{city_code}{City codes}
#' \item{city_kanji}{City names in japanese}
#' \item{geom}{Geometry data (polygon or multi-polygon type) of boundaries}
#' }
#' @examples
#' aichi_districts
#' @name aichi_districts
"aichi_districts"
