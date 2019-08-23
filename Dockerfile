FROM alpine:3.10

RUN apk add --no-cache --virtual .build-deps curl make gcc g++ libxslt \
    && curl -LfsSo /tmp/jemalloc-5.2.1.tar.bz2  https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 \
    && cd /tmp \
    && tar -jxf jemalloc-5.2.1.tar.bz2  \
    && cd jemalloc-5.2.1 \
    && ./configure \
    && make \
    && make install \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/jemalloc*

ENV JAVA_VERSION jdk8u222-b10

RUN set -eux; \
    apk add --virtual .fetch-deps curl; \
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
