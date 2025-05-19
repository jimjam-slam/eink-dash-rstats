# hass add-ons use alpine linux
# ARG BUILD_FROM
# FROM $BUILD_FROM

FROM rocker/r-ver:latest

RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev \
  libsodium-dev \
  libz-dev

EXPOSE 6123
  
RUN Rscript -e "install.packages(c('here', 'glue', 'plumber', 'httr2', 'dplyr'))"

COPY . /app
WORKDIR /app

ENTRYPOINT ["Rscript", "app.r"]
