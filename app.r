library(plumber)
library(glue)
source("hass.r")

pr("plumber.r") |> pr_run(host = "0.0.0.0", port = 6123)
