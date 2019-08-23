FROM alpine:3.10

RUN apk add --no-cache --virtual .build-deps curl make gcc g++ libxslt \
    && curl -LfsSo /tmp/jemalloc-5.2.1.tar.bz2  https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 \
    && cd /tmp \
    && tar -jxf jemalloc-5.2.1.tar.bz2  \
    && cd jemalloc-5.2.1 \
    && ./configure \
    && make \
    && make install \
    && apk del --purge .build-deps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/jemalloc*

RUN apk add -no-cache openjdk8 tini
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk \
    PATH=/usr/lib/jvm/java-1.8-openjdk/bin:$PATH
