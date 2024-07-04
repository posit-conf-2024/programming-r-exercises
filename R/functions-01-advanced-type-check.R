library("here")
library("rlang")
library("palmerpenguins")

# designed for package use
source(here("R/import-standalone-obj-type.R"), local = TRUE)
source(here("R/import-standalone-types-check.R"), local = TRUE)


# motivation seems to be to check arguments to functions,
# rather than types within a data frame

check_string("a")

check_string(c("hello", "world"))
check_character(c("hello", "world"))


is.numeric(penguins$bill_length_mm)

check_data_frame(mtcars)

# To get this to work in a package:
# - `usethis::use_standalone("r-lib/rlang", file = "types-check")`
# - `use_package_doc()`  space to import rlang namespace
# - in <name>-package.R insert `#' @import rlang`
# - document and check
#
# Be aware that you have the entire namespace of {rlang},
# as well as the functions in the imported files.
#
# At some point, it is imagined that these will be available as functions
# exported from an "r-lib" package.

# in the standalone files, there is no check_numeric
# roll your own, adapt `check_logical()`
check_numeric <- function(x,
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

to_z <- function(x, middle = 1) {
  # validate inputs
  check_numeric(x)
  check_number_decimal(middle)

  trim = (1 - middle)/2
  (x - mean(x, na.rm = TRUE, trim = trim)) / sd(x, na.rm = TRUE)
}

