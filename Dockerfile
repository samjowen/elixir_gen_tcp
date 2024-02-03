# syntax=docker/dockerfile:1

FROM hexpm/elixir:1.16.1-erlang-26.2.1-alpine-3.17.5
COPY ./ /app/
WORKDIR /app
RUN mix deps.get
RUN mix compile
CMD mix run --no-halt