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


#' get state of all home assistant entities
get_states <- function() {
  hass_request |>
    req_url_relative("api/states") |>
    req_perform() |>
    resp_body_json(simplifyVector = TRUE) |>
    tibble::as_tibble()
}

#' Get details needed to display scenes
get_scenes <- function() {
  get_states() |>
    filter(grepl("^scene\\.", entity_id)) |>
    mutate(
      icon = attributes$icon,
      friendly_name = attributes$friendly_name) |>
    select(entity_id, icon, friendly_name) |>
    # make the buttons
    mutate(
      btn = glue('
        <li>
          <form method="POST" action="/scene/activate">
            <input type="text" name="entity_id">
              {entity_id}
            </input>
            <button type="submit">
              <img
                aria-hidden="true"
                src="/assets/icons_baseline_{icon}_black_24dp.png">
              <span>{friendly_name}</span>
            </button>
          </form>
        </li>')) |>
    pull(btn) |>
    paste(collapse = "\n") |>
    paste('<ul id="scene-buttons">', x = _, "</ul>")
}

#' Make scene buttons
#' 