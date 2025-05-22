# hass add-ons use alpine linux
ARG BUILD_FROM=alpine:3.21.3
FROM $BUILD_FROM

# based on github.com/velaco/alpine-r
# (but i install r from apk so that rcpp builds properly)

ENV R_VER_MAJOR=4
ENV R_VER_MINOR=5.0
ENV R_SOURCE=/usr/local/src/R

ENV BUILD_DEPS="\
    cairo-dev \ 
    libxmu-dev \
    openjdk8-jre-base \ 
    pango-dev \
    perl \
    tiff-dev \
    tk-dev \
    wget \
    tar"

ENV PERSISTENT_DEPS="\
    libintl \
    gcc \
    g++ \
    gfortran \
    icu-dev \
    libjpeg-turbo \
    libpng-dev \
    make \
    openblas-dev \
    pcre-dev \
    pcre2-dev \
    readline-dev \
    xz-dev \
    zlib-dev \
    bzip2-dev \
    curl-dev \
    libsodium-dev"

# install system dependencies, then r
RUN apk upgrade --update
RUN apk add --no-cache --virtual .build-deps $BUILD_DEPS
RUN apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS
RUN apk add R R-dev

# cleanup dependencies
RUN apk del .build-deps

EXPOSE 6123

RUN Rscript -e "install.packages(c('here', 'glue', 'plumber', 'httr2', 'dplyr'), repos = 'https://cloud.r-project.org')"

COPY . /app
WORKDIR /app

ENTRYPOINT ["Rscript", "app.r"]
