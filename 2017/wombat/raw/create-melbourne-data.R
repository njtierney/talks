library(tidyverse)
library(bomrang)


# install_github("ToowoombaTrio/bomrang")

melb_weather_full <- get_current_weather("Melbourne (Olympic Park)")

melb_weather <- melb_weather_full %>%
  select(local_date_time,
         gust_kmh,
         air_temp,
         dewpt,
         rain_trace,
         rel_hum,
         wind_spd_kmh) %>%
  as_tibble

melb_weather

melb_times <- str_split(string = melb_weather$local_date_time,
                        pattern = "/",
                        simplify = TRUE)

tidy_melb_data <- as_tibble(melb_times) %>%
  rename(day = V1,
         time = V2) %>%
  mutate(month = if_else(day > 28,
                         true = "05",
                         false = "06"),
         year = "2017") %>%
  select(year,
         month,
         day,
         time) %>%
  mutate(ymd_hm_p = paste(year,month,day,time,
                          sep = "-"),
         ymd_hm = ymd_hm(ymd_hm_p)) %>%
  select(-ymd_hm_p) %>%
  bind_cols(melb_weather) %>%
  select(
    ymd_hm,
    time,
    gust_kmh,
    air_temp,
    rain_trace
  )

# readr::write_csv(tidy_melb_data, "data/tidy_melb_data.csv")
