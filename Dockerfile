# syntax=docker/dockerfile:1

FROM hexpm/elixir:1.16.1-erlang-26.2.1-alpine-3.17.5
COPY ./ /app/
WORKDIR /app
RUN ls -la
RUN mix deps.get
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix compile
ENTRYPOINT ["mix", "run", "--no-halt"]