# FROM elixir:1.5-alpine as asset-builder-mix-getter
FROM vizlegal/viztube:dev-201910 AS builder

LABEL vendor="vizlegal"

ENV HOME=/app APP=/app HEX_HOME=/deps/hex MIX_HOME=/deps/mix \
  MIX_ENV=prod

# Cache elixir deps
COPY config/ $APP/config/
COPY mix.exs mix.lock $APP/
COPY apps/viztube/config/ $APP/apps/viztube/config/
COPY apps/viztube/mix.exs $APP/apps/viztube/
COPY apps/viztube_web/config/ $APP/apps/viztube_web/config/
COPY apps/viztube_web/mix.exs $APP/apps/viztube_web/

WORKDIR $APP
RUN mix do deps.clean --all --only $MIX_ENV, deps.get --only $MIX_ENV

WORKDIR $APP/apps/viztube_web/assets
COPY apps/viztube_web/assets/ ./
RUN yarn install && ./node_modules/.bin/brunch build --production

WORKDIR $APP

RUN mv $APP/deps /tmp/deps && \
  mv $APP/apps/viztube_web/priv/static /tmp/static

ARG ERLANG_COOKIE
ENV ERLANG_COOKIE $ERLANG_COOKIE

COPY . $APP/

RUN mv /tmp/deps . && \
  mv /tmp/static apps/viztube_web/priv/static

WORKDIR $APP/apps/viztube_web
RUN mix phx.digest

# Release
WORKDIR $APP
RUN mix release --env=$MIX_ENV

########################################################################
FROM bitnami/minideb:stretch

ENV LANG=C.UTF-8 \
    HOME=/app/ APP=/app/ \
    TERM=xterm

ENV VIZTUBE_VERSION=0.2.0

RUN install_packages locales && \
  locale-gen C.UTF-8 && \
  update-locale LANG=C.UTF-8 && \
  install_packages bash libncurses5 openssl libssl1.0.2

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod \
    REPLACE_OS_VARS=true \
    SHELL=/bin/sh

COPY --from=builder $APP/_build/prod/rel/viztube_umbrella/releases/$VIZTUBE_VERSION/viztube_umbrella.tar.gz $APP

WORKDIR $APP
RUN tar -xzf viztube_umbrella.tar.gz

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
