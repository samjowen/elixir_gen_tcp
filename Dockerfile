# syntax=docker/dockerfile:1

FROM elixir:1.15-alpine
COPY ./ /app/
WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix compile
CMD mix run --no-halt