defmodule ViztubeWeb.AuthenticationEmail do
  use Bamboo.Phoenix, view: ViztubeWeb.EmailView

  import Bamboo.Email

  def login_link(token_value, user) do
    new_email()
    |> to(user.email)
    |> from("system@vizlegal.io")
    |> subject("Your login link for Viztube")
    |> assign(:token, token_value)
    |> render("login_link.html")
  end
end
