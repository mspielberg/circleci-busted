FROM alpine

ENV LUA_VERSION=5.2.4
ENV LUAROCKS_VERSION=3.0.4

RUN set -ex \
    \
    && apk add --no-cache \
        ca-certificates \
        git \
        dropbear-ssh \
        readline \
    \
    && apk add --no-cache --virtual .build-deps \
        curl \
        gcc \
        libc-dev \
        make \
        openssl \
        readline-dev \
        unzip \
    \
    && wget -c https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz \
        -O - | tar -xzf - \
    \
    && cd lua-${LUA_VERSION} \
    && make -j"$(nproc)" linux \
    && make install \
    && cd .. \
    && rm -rf lua-${LUA_VERSION} \
    \
    && wget -c https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz \
        -O - | tar -xzf - \
    \
    && cd luarocks-${LUAROCKS_VERSION} \
    && ./configure --with-lua=/usr/local \
    && make install \
    && cd .. \
    && rm -rf luarocks-${LUAROCKS_VERSION} \
    \
    && luarocks install busted \
    && luarocks install inspect \
    && luarocks install serpent \
    \
    && apk del .build-deps

CMD ["lua"]
