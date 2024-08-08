# syntax=docker/dockerfile:1
# Multistage build image
FROM alpine:latest AS build
ARG IPERF3_VER=3.17.1
WORKDIR /src
RUN apk --no-cache add make gcc g++ musl-dev binutils autoconf automake libtool pkgconfig check-dev file patch
RUN apk --no-cache add curl
RUN apk --no-cache add openssl-dev
RUN curl -o iperf-${IPERF3_VER}.tar.gz https://downloads.es.net/pub/iperf/iperf-${IPERF3_VER}.tar.gz
RUN curl -o iperf-${IPERF3_VER}.tar.gz.sha256 https://downloads.es.net/pub/iperf/iperf-${IPERF3_VER}.tar.gz.sha256
RUN echo "$(cat iperf-${IPERF3_VER}.tar.gz.sha256)" | sha256sum -c
RUN tar -xvf iperf-${IPERF3_VER}.tar.gz
RUN cd iperf-${IPERF3_VER};./configure --disable-static --bindir=/bin --libdir=/lib
RUN cd iperf-${IPERF3_VER};make
RUN cd iperf-${IPERF3_VER};make install

# Actual application image with binaries copied from build image
FROM alpine:latest
EXPOSE 5201/tcp 5201/udp
COPY --from=build /bin/iperf* /bin/
COPY --from=build /lib/libiperf* /lib/
RUN adduser -S iperf3
USER iperf3
ENTRYPOINT ["iperf3"]
