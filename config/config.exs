# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chat, ecto_repos: [Chat.Repo]

# Configures the endpoint
config :chat, ChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VjAEDogW0oU4uS/tICcVb+NwMPxb9IbZZwe5ZQK2t/g9ZIussOAceYI66lLgXAjk",
  render_errors: [view: ChatWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Chat.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configure Guardian
config :chat, ChatWeb.Guardian,
  issuer: "chat",
  secret_key: "aHWQAVBy/y8mn3f2xBArth4JhzIYJSnNZGE7m3nVG+wJzig+76hKP9+NCOGJV9Yy",
  verify_issuer: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
