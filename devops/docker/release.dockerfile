################################################################################
# Dockerfile for building the production release from any dev machine.
# When changing the elixir version here, you must match its alpine version in
# `devops/Dockerfile`.
FROM elixir:1.10-alpine AS builder

ARG APP_NAME
ARG APP_VSN

ARG MIX_ENV=prod
ARG SKIP_PHOENIX=false

ENV SKIP_PHOENIX=${SKIP_PHOENIX} \
    APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

RUN \
  apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    nodejs \
    yarn \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

COPY . .

RUN mix do deps.get, deps.compile, compile

RUN if [ ! "$SKIP_PHOENIX" = "true" ]; then \
  yarn --cwd assets install && \
  yarn --cwd assets deploy && \
  mix phx.digest; \
fi

RUN mix release ${APP_NAME}

RUN ls /opt/app/_build/${MIX_ENV}/rel/${APP_NAME}

# Stage two, release

FROM alpine:3.11

ARG APP_NAME
ARG APP_VSN

ARG MIX_ENV=prod

ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

RUN apk update && \
    apk add --no-cache \
      bash \
      openssl-dev

WORKDIR /opt/app

COPY --from=builder /opt/app/_build/${MIX_ENV}/rel/${APP_NAME}/ .

CMD trap 'exit' INT; bin/${APP_NAME} start
