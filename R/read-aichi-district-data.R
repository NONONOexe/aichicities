#' Read the Aichi Prefecture administrative district data
#'
#' @description
#' Read the Aichi Prefecture administrative district data.
#'
#' @param file A file path of data to read.
#' @return Information on administrative areassuch as cities and wards
#' in Aichi prefecture.
#'
#' @format Each is a tibble with 69 rows 6 variables:
#' \describe{
#' \item{city}{City names}
#' \item{city_code}{City codes}
#' \item{city_kanji}{City names in japanese}
#' \item{geom}{Geometry data (polygon or multi-polygon type) of boundaries}
#' }
#'
#' @export
#' @examples
#' \dontrun{
#' aichi_districts <- read_aichi_district_data("N03-20210101_23_GML.zip")
#' }
read_aichi_district_data <- function(file) {
  # Unzip the file.
  cli_progress_step("Unzipping the file into {.path {tempdir()}}")
  unzipped_path <- unzip(file, exdir = tempdir())

  # Data frame of city names.
  city_names <- tibble(
    "city_code" = c("23101", "23102", "23103", "23104", "23105", "23106",
                    "23107", "23108", "23109", "23110", "23111", "23112",
                    "23113", "23114", "23115", "23116", "23201", "23202",
                    "23203", "23204", "23205", "23206", "23207", "23208",
                    "23209", "23210", "23211", "23212", "23213", "23214",
                    "23215", "23216", "23217", "23219", "23220", "23221",
                    "23222", "23223", "23224", "23225", "23226", "23227",
                    "23228", "23229", "23230", "23231", "23232", "23233",
                    "23234", "23235", "23236", "23237", "23238", "23302",
                    "23342", "23361", "23362", "23424", "23425", "23427",
                    "23441", "23442", "23445", "23446", "23447", "23501",
                    "23561", "23562", "23563"),
    "city" = c(paste("Nagoya-shi", c("Chikusa-ku", "Higashi-ku", "Kita-ku",
                                     "Nishi-ku", "Nakamura-ku", "Naka-ku",
                                     "Showa-ku", "Mizuho-ku", "Atsuta-ku",
                                     "Nakagawa-ku", "Minato-ku", "Minami-ku",
                                     "Moriyama-ku", "Midori-ku", "Meito-ku",
                                     "Tenpaku-ku")),
               "Toyohashi-shi", "Okazaki-shi", "Ichinomiya-shi", "Seto-shi",
               "Handa-shi", "Kasugai-shi", "Toyokawa-shi", "Tsushima-shi",
               "Hekinan-shi", "Kariya-shi", "Toyota-shi", "Anjo-shi",
               "Nishio-shi", "Gamagori-shi", "Inuyama-shi", "Tokoname-shi",
               "Konan-shi", "Komaki-shi", "Inazawa-shi", "Shinshiro-shi",
               "Tokai-shi", "Obu-shi", "Chita-shi", "Chiryu-shi",
               "Owariasahi-shi", "Takahama-shi", "Iwakura-shi", "Toyoake-shi",
               "Nisshin-shi", "Tahara-shi", "Aisai-shi", "Kiyosu-shi",
               "Kitanagoya-shi", "Yatomi-shi", "Miyoshi-shi", "Ama-shi",
               "Nagakute-shi", "Aichi-gun Togo-cho",
               "Nishikasugai-gun Toyoyama-cho", "Tanba-gun Oguchi-cho",
               "Tanba-gun Fuso-cho", "Ama-gun Oharu-cho", "Ama-gun Kanie-cho",
               "Ama-gun Tobishima-mura", "Chita-gun Agui-cho",
               "Chita-gun Higashiura-cho", "Chita-gun Minamichita-cho",
               "Chita-gun Mihama-cho", "Chita-gun Taketoyo-cho",
               "Nukata-gun Kota-cho", "Kitashitara-gun Shitara-cho",
               "Kitashitara-gun Toei-cho", "Kitashitara-gun Toyone-mura")
  )

  # Create a data frame of city names and codes.
  shp_data_path <- unzipped_path[endsWith(unzipped_path, ".shp")]
  cli_progress_step("Reading the district data into a tibble")
  aichi_districts <- shp_data_path |>
    read_sf(options = "ENCODING=CP932", stringsAsFactors = FALSE) |>
    transmute(city_code  = .data$N03_007,
              city_kanji = str_trim(str_c(str_replace_na(.data$N03_002, ""),
                                          str_replace_na(.data$N03_003, ""),
                                          str_replace_na(.data$N03_004, ""),
                                          sep = " "))) |>
    group_by(.data$city_code, .data$city_kanji) |>
    summarise(geom = st_union(.data$geometry), .groups = "drop") |>
    inner_join(city_names, by = join_by("city_code")) |>
    mutate(area = st_area(.data$geom)) |>
    arrange(.data$city_code) |>
    relocate("city_code", "city", "city_kanji", "area") |>
    st_transform(crs = 4326)

  return(aichi_districts)
}
