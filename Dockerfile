ARG ARCH
ARG VERSION
ARG BUILD_DATE

# Base image
FROM debian:bullseye-slim
ARG ARCH
ARG VERSION
ARG BUILD_DATE

# Dependencies
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y --no-install-recommends toilet && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
    
# Switch to working directory for our app
WORKDIR /opt/chirpstack

# Checkout and compile remote code
RUN mkdir -p binaries
ARG DOWNLOAD_FROM=https://github.com/xoseperez/chirpstack-concentratord/releases/download
ARG FILE=chirpstack-concentratord
ADD --chmod=666 ${DOWNLOAD_FROM}/${VERSION}/${FILE}-sx1301_${VERSION}_${ARCH}.tar.gz ./binaries/${FILE}-sx1301.tar.gz
ADD --chmod=666 ${DOWNLOAD_FROM}/${VERSION}/${FILE}-sx1302_${VERSION}_${ARCH}.tar.gz ./binaries/${FILE}-sx1302.tar.gz
ADD --chmod=666 ${DOWNLOAD_FROM}/${VERSION}/${FILE}-2g4_${VERSION}_${ARCH}.tar.gz ./binaries/${FILE}-2g4.tar.gz

# Copy fles from builder and repo
COPY ./runner/ ./
RUN chmod +x start
RUN chmod 777 .

# Run as nobody
USER nobody:nogroup

# Add application folder to path
ENV PATH="${PATH}:/opt/chirpstack"

# Launch our binary on container startup.
CMD ["bash", "start"]
