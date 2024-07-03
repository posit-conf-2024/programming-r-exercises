library("here")
library("rlang")
library("palmerpenguins")

source(here("R/import-standalone-obj-type.R"), local = TRUE)
source(here("R/import-standalone-types-check.R"), local = TRUE)


# motivation seems to be to check arguments to functions, rather than types within a data frame

check_string("a")

check_string(c("hello", "world"))
check_character(c("hello", "world"))

check_data_frame(mtcars)

