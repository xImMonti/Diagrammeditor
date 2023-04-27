import Config

if config_env() in [:prod, :dev] do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("HOST") || "diagrammeditor.example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")
  url_port = String.to_integer(System.get_env("URL_PORT") || "4000")
  url_scheme = System.get_env("URL_SCHEME") || "http"

  config :diagrammeditor, DiagrammeditorWeb.Endpoint,
    url: [
      host: host,
      port: url_port,
      scheme: url_scheme
    ],
    http: [
      ip: {0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base,
    server: true
end
