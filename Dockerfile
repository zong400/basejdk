FROM alpine:3.10

RUN apk add --no-cache --virtual .build-deps curl make gcc g++ libxslt \
    && curl -LfsSo /tmp/jemalloc.tar.bz2 https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 \
    && cd /tmp \
    && tar -jxf jemalloc.tar.bz2 \
    && cd jemalloc \
    && ./configure \
    && make \
    && make install \
    && apk del --purge .build-deps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/jemalloc*

RUN apk add -no-cache openjdk8 tini