FROM alpine:3.8
ENV JAVA_VERSION jdk8u222-b10

RUN set -eux; \
    apk add --virtual .fetch-deps curl jemalloc tini; \
    ESUM='37356281345b93feb4212e6267109b4409b55b06f107619dde4960e402bafa77'; \
    BINARY_URL='https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz'; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    apk del --purge .fetch-deps; \
    rm -rf /var/cache/apk/*; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH" \
	LD_PRELOAD=/usr/lib/libjemalloc.so.2
	
RUN echo 'Asia/Shanghai' >/etc/timezone; \
    mkdir /app; && \
    addgroup -g 1000 java; && \
    adduser -D -u 1000 -G java java; && \
    chown java:java /app;
WORKDIR /app
USER java
