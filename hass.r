library(glue)
library(dplyr)
library(httr2)

hass_ip    <- Sys.getenv("HASS_IP")
hass_port  <- Sys.getenv("HASS_PORT")
hass_token <- Sys.getenv("HASS_TOKEN")

glue("http://{hass_ip}:{hass_port}") |>
  request() |>
  req_headers(
    "Content-Type" = "application/json",
    "Authorization" = glue("Bearer {hass_token}")) ->
hass_request

# requests --------------------------------------------
# these functions do the actual GETting and POSTing to hass

#' get state of all home assistant entities
get_states <- function() {
  hass_request |>
    req_url_relative("api/states") |>
    req_perform() |>
    resp_body_json(simplifyVector = TRUE) |>
    tibble::as_tibble()
}

# state queries ------------------------------------
# these query the above state getter and filter it down for
# various uses

#' Get details needed to display scenes
get_scenes <- function() {
  # retrieve the states
  get_states() |>
    filter(grepl("^scene\\.", entity_id)) |>
    mutate(
      icon = attributes$icon,
      friendly_name = attributes$friendly_name) |>
    select(entity_id, icon, friendly_name)
    
}

# template constructors ----------------------------
# these build ui from the above state functions and html templates/

#' Make scene buttons
#' 
make_scene_buttons <- function() {
  file.path("templates", "scene-button.html") |>
    readLines() |>
    paste(collapse = "\n") ->
  btn_template
  
  get_scenes() |>
    mutate(btn = glue(btn_template)) |>
    pull(btn) |>
    paste(collapse = "\n")
}

