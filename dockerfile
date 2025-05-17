FROM rocker/r-ver:latest

RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev \
  libsodium-dev \
  libz-dev

EXPOSE 6123
  
RUN Rscript -e "install.packages(c('here', 'glue', 'plumber'))"

COPY . /app
WORKDIR /app

ENTRYPOINT ["Rscript", "app.r"]
