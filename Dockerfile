ARG ARCH
ARG UPSTREAM_VERSION=4.7.1-r1

# Base image
FROM alpine:3.19

# Variables
ARG ARCH
ARG UPSTREAM_VERSION
ARG BUILD_DATE
ARG WORKDIR=/opt/chirpstack
ARG OWNER=xoseperez
ARG FILE=chirpstack-concentratord
ARG DOWNLOAD_FROM=https://github.com/${OWNER}/${FILE}/releases/download

# Dependencies
RUN apk add --no-cache bash

# Switch to working directory for our app
WORKDIR ${WORKDIR}

# Checkout and compile remote code
RUN mkdir -p binaries
ADD --chmod=666 ${DOWNLOAD_FROM}/v${UPSTREAM_VERSION}/${FILE}-sx1301_${UPSTREAM_VERSION}_${ARCH}.tar.gz ./binaries/${FILE}-sx1301.tar.gz
ADD --chmod=666 ${DOWNLOAD_FROM}/v${UPSTREAM_VERSION}/${FILE}-sx1302_${UPSTREAM_VERSION}_${ARCH}.tar.gz ./binaries/${FILE}-sx1302.tar.gz
ADD --chmod=666 ${DOWNLOAD_FROM}/v${UPSTREAM_VERSION}/${FILE}-2g4_${UPSTREAM_VERSION}_${ARCH}.tar.gz ./binaries/${FILE}-2g4.tar.gz

# Copy fles from builder and repo
COPY ./runner/ ./
RUN chmod +x start gateway_eui
RUN chmod 777 .

# Run as nobody
USER nobody:nogroup

# Add application folder to path
ENV PATH="${PATH}:${WORKDIR}"

# Launch our binary on container startup.
CMD ["bash", "start"]
