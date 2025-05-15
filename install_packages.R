# install_packages.R

packages <- c("shiny", "dplyr", "ggplot2", "plotly", "Lahman", "readr")

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

invisible(lapply(packages, install_if_missing))
