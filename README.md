# eink-dash-rstats

Inspired by [FI-153/eInk_dashboard](https://github.com/FI-153/eInk_dashboard), but this one uses an R plumber API (instead of Python and Flask) and is more geared toward 

## Config

Add an `.Renviron` file to the project root and fill in the following values:

```env
HASS_IP=
HASS_PORT=
HASS_TOKEN=
```

No entity IDs required presently, as this dashboard displays buttons to activate all existing scenes.

## Local development

```bash
docker build -t eink-dash:latest .
docker run -p 6123:6123 eink-dash:latest
```

## Customisation

The app has code split across a few files:

- `app.r`: entrypoint, starts Plumber
- `plumber.r`: API endpoints. The Plumber API is a go-between for Home Assistant and the dashboard: HTML pages are retrieved through GET requests, and changes are made to Home Assistant via POST requests.
- `hass.r`: functions that query and update Home Assistant via its own RESTful API. There are also functions that transform HASS state further (mostly by rendering HTML `/templates` using it).
- `/templates`: HTML fragments or pages that are used to create the dashboard page.
- `/assets`: CSS and icons are kept here.