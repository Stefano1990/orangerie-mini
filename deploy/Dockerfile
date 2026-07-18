# Builds an x86_64 Linux release and exports it as a tarball.
# Usage: docker build --platform linux/amd64 -f deploy/Dockerfile -o deploy/_out .
FROM hexpm/elixir:1.19.5-erlang-28.5.0.3-debian-bookworm-20260623-slim AS build

RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ENV MIX_ENV=prod
# Needed to run the BEAM JIT under Rosetta emulation on Apple Silicon
ENV ERL_FLAGS="+JMsingle true"

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

COPY config config
RUN mix deps.compile
RUN mix localize.download_locales

COPY assets assets
COPY priv priv
COPY lib lib

RUN mix compile
RUN mix assets.deploy
RUN mix release

RUN tar -czf /orangerie.tar.gz -C _build/prod/rel/orangerie .

FROM scratch
COPY --from=build /orangerie.tar.gz /
