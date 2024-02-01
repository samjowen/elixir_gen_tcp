# syntax=docker/dockerfile:1

FROM alpine:3.19.1
RUN apk add elixir
COPY ./lib /app
COPY ./mix.exs /app
RUN cd /app
RUN mix compile
CMD mix run --no-halt