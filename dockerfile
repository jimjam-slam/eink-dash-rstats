# hass add-ons use alpine linux
# ARG BUILD_FROM=alpine:3.21.3
# FROM $BUILD_FROM

FROM rocker/r-ver:latest

#$ TODO - no apt on alpine

RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev \
  libsodium-dev \
  libz-dev \
  r-base \
  r-base-dev

EXPOSE 6123
  
RUN Rscript -e "install.packages(c('here', 'glue', 'plumber', 'httr2', 'dplyr'))"

COPY . /app
WORKDIR /app

ENTRYPOINT ["Rscript", "app.r"]
