library("here")
library("rlang")
library("palmerpenguins")

# function without type checking
to_z <- function(x, middle = 1) {
  trim = (1 - middle)/2
  (x - mean(x, na.rm = TRUE, trim = trim)) / sd(x, na.rm = TRUE)
}

# will throw error, but could be clearer
to_z(penguins$bill_length_mm, middle = "1")


# -----------
# use type-checking functions from {rlang}

# bring checking functions into environment
source(here("R/import-standalone-obj-type.R"), local = TRUE)
source(here("R/import-standalone-types-check.R"), local = TRUE)

# check `middle`
to_z_check <- function(x, middle = 1) {

  check_number_decimal(middle)

  trim = (1 - middle)/2
  (x - mean(x, na.rm = TRUE, trim = trim)) / sd(x, na.rm = TRUE)
}

# error is clearer here
to_z_check(penguins$bill_length_mm, middle = "1")


# -----------
# make your own type-checking function

# simplified attempt
check_numeric <- function(x, allow_null = FALSE) {

  # predicate
  if (!missing(x)) {
    if (is.numeric(x)) return(invisible(NULL))
    if (allow_null && is_null(x)) return(invisible(NULL))
  }

  # stop
  stop_input_type(x, "a numeric vector")
}

# use simplified checker
to_z_check_even_more <- function(x, middle = 1) {

  check_numeric(x) # this is "our" function, not a "standard" checker
  check_number_decimal(middle)

  trim = (1 - middle)/2
  (x - mean(x, na.rm = TRUE, trim = trim)) / sd(x, na.rm = TRUE)
}

to_z_check_even_more(penguins$sex, middle = 1)


# -----------
# more detail

# this is what a "full" checker might look like
check_numeric_full <- function(x,
                               ...,
                               allow_null = FALSE,
                               arg = caller_arg(x),
                               call = caller_env()) {

  # predicate
  if (!missing(x)) {
    if (is.numeric(x)) {
      return(invisible(NULL))
    }
    if (allow_null && is_null(x)) {
      return(invisible(NULL))
    }
  }

  # throw error
  stop_input_type(
    x,
    "a numeric vector",
    ...,
    allow_na = FALSE,
    allow_null = allow_null,
    arg = arg,
    call = call
  )
}

# use full checker in function
to_z_full <- function(x, middle = 1) {
  # validate inputs
  check_numeric_full(x)
  check_number_decimal(middle)

  trim = (1 - middle)/2
  (x - mean(x, na.rm = TRUE, trim = trim)) / sd(x, na.rm = TRUE)
}

# try it out
to_z_full(penguins$sex, middle = 1)
