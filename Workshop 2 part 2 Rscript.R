file <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=44025h2011.txt.gz&dir=data/historical/stdmet/"
readLines(file, n = 4)

buoy44025 <- read_table(file,
                        col_names = F,
                        skip = 2)
buoy44025

names(buoy44025)
## Fix the names
measure <- scan(file,
                nlines = 1,
                what = character()) %>%
  str_remove("#")

units <- scan(file,
              skip = 1,
              nlines = 1,
              what = character()) %>%
  str_remove("#") %>%
  str_replace("/", "_per_")

names(buoy44025) <- paste(measure, units, sep = "_")
names(buoy44025)
