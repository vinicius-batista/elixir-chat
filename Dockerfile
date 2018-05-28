FROM elixir:1.6

# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client

# Install phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

WORKDIR /app
EXPOSE 4000
