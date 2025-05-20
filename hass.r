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

# requests --------------------------------------------------------------------
# these functions do the actual GETting and POSTing to hass

#' get state of all home assistant entities
get_states <- function() {
  hass_request |>
    req_url_relative("api/states") |>
    req_perform() |>
    resp_body_json(simplifyVector = TRUE) |>
    tibble::as_tibble()
}

# state queries ---------------------------------------------------------------
# these query the above state getter and filter it down for various uses

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

# template constructors -------------------------------------------------------
# these build ui from the above state functions and html templates/

make_redirect_to_home <- function() {
  readLines(file.path("templates", "redirect-to-home.html")) |>
    paste(collapse = "\n")
}

make_home <- function() {
  # TODO - turn get_state() into a closure to cache over course of request
  readLines(file.path("templates", "home.html")) |>
    paste(collapse = "\n") |>
    glue()
}

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

# helpers ---------------------------------------------------------------------

#' Get static icon path (or fallback) from home assistant identifier
icon_path <- function(ids) {

  # convert identifiers to paths
  stripped_ids <- sub("^mdi:", "", x = ids)
  icon_paths <- file.path(
    "assets",
    "icons",
    glue("baseline_{ stripped_ids }_black_24dp.png"))

  # replace missing icons with fallback
  icon_paths[!file.exists(icon_paths)] <-
    file.path("assets", "icons", "baseline_stars_black_24dp.png")

  icon_paths
}