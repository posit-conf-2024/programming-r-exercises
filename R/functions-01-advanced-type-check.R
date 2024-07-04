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
