# syntax=docker/dockerfile:1

FROM elixir:1.15-alpine
COPY ./ /app/
WORKDIR /app
RUN mix deps.get
RUN mix compile
CMD mix run --no-halt