#
# jdownloader-2 Dockerfile
#
# https://github.com/jlesage/docker-jdownloader-2
#
# NOTES:
#   - We are using JRE version 8 because recent versions are much bigger.
#   - JRE for ARM 32-bits on Alpine is very hard to get:
#     - The version in Alpine repo is very, very slow.
#     - The glibc version doesn't work well on Alpine with a compatibility
#       layer (gcompat or libc6-compat).  The `__xstat` symbol is missing and
#       implementing a wrapper is not straight-forward because the `struct stat`
#       is not constant across architectures (32/64 bits) and glibc/musl.
#
ARG DOCKER_IMAGE_VERSION=

ARG VERSION=2.4.1
ARG MCA_DOWNLOAD_URL="https://github.com/Querz/mcaselector/releases/download/${VERSION}/mcaselector-${VERSION}.jar"
ARG JAVAFX_DOWNLOAD_URL="https://download2.gluonhq.com/openjfx/21.0.3/openjfx-21.0.3_linux-x64_bin-sdk.zip"

# Download dependencies
FROM alpine:3.16 AS downloader
ARG MCA_DOWNLOAD_URL
ARG JAVAFX_DOWNLOAD_URL
RUN \
    apk add --no-cache curl unzip && \
    curl -# -L -o /mcaselector.jar "$MCA_DOWNLOAD_URL" && \
    curl -# -L -o /openjfx.zip "$JAVAFX_DOWNLOAD_URL" && \
    unzip /openjfx.zip -d /openjfx

# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-22.04-v4.6.3

ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

RUN \
    apt update && \
    apt install -y openjdk-21-jre && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
COPY rootfs/ /
# Generate and install favicons.
RUN \
    APP_ICON_URL="file:///defaults/icon.png" && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.

COPY --from=downloader /mcaselector.jar /defaults/mcaselector.jar
COPY --from=downloader /openjfx/javafx-sdk-21.0.3 /openjfx

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "MCASelector" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

VOLUME [ "/world", "/config" ]

# Metadata.
LABEL \
      org.label-schema.name="mcaselector" \
      org.label-schema.description="Docker container for MCASelector" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-jdownloader-2" \
      org.label-schema.schema-version="1.0"
