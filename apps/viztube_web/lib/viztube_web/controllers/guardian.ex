defmodule ViztubeWeb.Guardian do

  use Guardian, otp_app: :viztube_web

  alias Viztube.Accounts

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    user = claims["sub"]
    |> Accounts.get_user!
    {:ok, user}
  end

end
