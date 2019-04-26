defmodule ViztubeWeb.GuardianAuthPipeline do

  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
    otp_app: :viztube_web,
    module: ViztubeWeb.Guardian,
    error_handler: ViztubeWeb.GuardianAuthErrorHandler

  plug Guardian.Plug.VerifySession, claims: @claims
  plug Guardian.Plug.VerifyHeader, claims: @claims
  plug Guardian.Plug.LoadResource, ensure: true, allow_blank: true
end
