library(pdftools)
library(dplyr)
library(stringr)
library(purrr)
library(lubridate)

# function to download and clean a single F-6 weather form from
# the Mt. Washington Obseratory
get_F6_df <- function(year, month){

  m <- ifelse(str_length(as.character(month)) == 1, paste0("0", month), as.character(month))

  url <- paste0("https://www.mountwashington.org/uploads/forms/", year, "/", m, ".pdf")

  f6_text <- pdf_text(url) %>%
    readr::read_lines()

  table_bottom <- if(as.integer(month) == 2L & year %% 4 != 0) 28 else which(str_detect(f6_text, "SUM")) -1

  pdf_table <- f6_text[10: table_bottom] %>%
    # fix one day with missing opening parentheses in wind direction
    str_replace(fixed("320 NW)"), "320 (NW)") %>%
    # collapse space in wind direction column
    str_replace(" \\(", "\\(") %>%
    str_replace(", ", ",") %>%
    # replace all instances of multiple spaces with a single space
    str_replace_all("[:space:]{2,}"," ")

  table_split <- str_split(str_trim(pdf_table), pattern = "[:blank:]")

  table_split <- map(table_split, function(x){
    if(length(x) == 17){
      return(c(x, "NA"))
    } else {
      x
    }
  })

  pdf_table <- map(table_split, ~ str_c(., sep = "", collapse = " ")) %>%
    unlist()

  dat <- read.table(textConnection(pdf_table), header = FALSE, stringsAsFactors = FALSE)

  names(dat) <- c("Day", "Max.temperature", "Min.temperature", "Avg.temperature", "Norm.temperature",
                  "Depart.temperature", "DD.heat", "DD.cool", "Total.equiv.precipitation",
                  "Snow.ice.precipitation", "Snow.ice.onground", "Avg.wind.speed", "Fastest.wind.speed",
                  "Fastest.wind.direction", "Total.sunshine.minutes", "Percent.possible.sunshine.minutes",
                  "Sky.cover", "weather.occur")


  dat$weather.occur <- as.character(dat$weather.occur)


  weather_symbols <- c(as.character(1:9), "X")
  symbol_meanings <- c("FOG", "FOG REDUCING VISIBIBILITY TO QUARTER MILE OR LESS", "THUNDER", "ICE PELLETS",
                       "HAIL", "GLAZE OR RIME", "BLOWING DUST OR SAND RED. VIS. TO HALF MILE OR LESS",
                       "SMOKE OR HAZE", "BLOWING SNOW", "TORNADO")
  names(symbol_meanings) <- weather_symbols


  dat$weather.occur <- sapply(strsplit(dat$weather.occur, ""), paste, collapse=", ")
  dat$weather.occur <- str_replace_all(dat$weather.occur, symbol_meanings) %>%
    str_replace_all(c("QUARTER" = "1/4", "HALF" = "1/2"))

  # used in pipeline below as an argument to multiple
  precip_cols <- c("Total.equiv.precipitation", "Snow.ice.precipitation", "Snow.ice.onground")

  # handle dates that have "T" for "trace" in one of the precipitation columns
  dat <- dat %>%
    mutate_at(precip_cols, ~ str_remove_all(., fixed("*"))) %>%
    mutate(Trace.precipitation = Total.equiv.precipitation == "T",
           Trace.snow.ice.precipitation = Snow.ice.precipitation == "T",
           Trace.snow.ice.onground = Snow.ice.onground == "T") %>%
    # select columns in right order
    select(1:8, Total.equiv.precipitation, Trace.precipitation, Snow.ice.precipitation,
           Trace.snow.ice.precipitation, Snow.ice.onground, Trace.snow.ice.onground, 12:18) %>%
    # now that we have columns indicating which days have trace amounts of precipitation,
    # let's get rid of the "T"
    mutate_at(precip_cols,
              function(x){
                as.numeric(str_replace(x, "T", "0.0"))
              }) %>%
    mutate(Day = mdy(paste(month, Day, year, sep = "-"))) %>%
    rename(Date = Day) %>%
    mutate(Avg.wind.speed = as.numeric(str_replace(Avg.wind.speed, "\\.$", "")))
  dat
}

# function to create a data frame with all available data
getMtWashingtonWeather <- function(){

  current_date <- Sys.Date()

  current_year <- year(current_date)
  current_month <- month(current_date)


  years <- 2005: current_year

  years <- lapply(years, function(x){
    rep(x, 12)
  }) %>% unlist()

  all_months <- data.frame(year = years, month = 1:12) %>%
    filter(!(year == current_year & month >= current_month)) %>%
    mutate(data = map2(year, month, ~ get_F6_df(.x, .y)))

  do.call(rbind, all_months$data)
}

mountWashington <- getMtWashingtonWeather()

write.csv(mountWashington, "data-raw/mtWashington.csv", row.names = FALSE)

usethis::use_data(mountWashington, overwrite = TRUE)
