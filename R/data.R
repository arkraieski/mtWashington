#' @title Mount Washington Weather
#' @description The data was extracted from monthly F6 weather forms from the Mount Washington Observatory, which is located on the summit of Mt. Washington in New Hampshire, USA. It includes various daily weather measurements from 2005 to 2020.
#' @format A data frame with 5705 rows and 21 variables:
#' \describe{
#'   \item{\code{Date}}{double COLUMN_DESCRIPTION}
#'   \item{\code{Max.temperature}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{Min.temperature}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{Avg.temperature}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{Norm.temperature}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{Depart.temperature}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{DD.heat}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{DD.cool}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{Total.equiv.precipitation}}{double COLUMN_DESCRIPTION}
#'   \item{\code{Trace.precipitation}}{logical COLUMN_DESCRIPTION}
#'   \item{\code{Snow.ice.precipitation}}{double COLUMN_DESCRIPTION}
#'   \item{\code{Trace.snow.ice.precipitation}}{logical COLUMN_DESCRIPTION}
#'   \item{\code{Snow.ice.onground}}{double COLUMN_DESCRIPTION}
#'   \item{\code{Trace.snow.ice.onground}}{logical COLUMN_DESCRIPTION}
#'   \item{\code{Avg.wind.speed}}{double COLUMN_DESCRIPTION}
#'   \item{\code{Fastest.wind.speed}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{Fastest.wind.direction}}{character COLUMN_DESCRIPTION}
#'   \item{\code{Total.sunshine.minutes}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{Percent.possible.sunshine.minutes}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{Sky.cover}}{integer COLUMN_DESCRIPTION}
#'   \item{\code{weather.occur}}{character COLUMN_DESCRIPTION}
#'}
#' @source \url{https://www.mountwashington.org/experience-the-weather/mount-washington-weather-archives/monthly-f6.aspx}
"mountWashington"
