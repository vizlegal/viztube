defmodule ViztubeWeb.TokenAuthentication do
  import Ecto.Query, only: [where: 3]

  alias Viztube.{AuthToken, Repo}
  alias Viztube.Accounts.{AuthToken,User}
  alias ViztubeWeb.{Mailer, AuthenticationEmail, Endpoint}
  alias Phoenix.Token

  @token_max_age 1_800

  def provide_token(nil), do: {:error, :not_found}

  def provide_token(email) when is_binary(email) do
    User
    |> Repo.get_by(email: email)
    |> send_token()
  end

  def provide_token(_user = %User{}) do
    send_token()
  end

  def verify_token_value(value) do
    AuthToken
    |> where([t], t.value == ^value)
    |> where([t], t.inserted_at > datetime_add(^NaiveDateTime.utc_now, ^(@token_max_age * -1), "second"))
    |> Repo.one()
    |> verify_token()
  end

  @doc false
  defp verify_token(nil), do: {:error, :invalid}

  @doc false
  defp verify_token(token) do
    token =
      token
      |> Repo.preload(:user)
      |> Repo.delete!

    user_id = token.user.id

    case Token.verify(Endpoint, "user", token.value, max_age: @token_max_age) do
      {:ok, ^user_id} ->
        {:ok, token.user}
      # reason can be :invalid or :expired
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc false
  defp send_token(), do: {:error, :not_found}

  @doc false
  defp send_token(user) do
    if (user) do
      user
      |> create_token()
      |> AuthenticationEmail.login_link(user)
      |> Mailer.deliver_now()

      {:ok, user}
    else
      {:error, "error"}
    end
  end

  @doc false
  # Creates a new token for the given user and returns the token value.
  defp create_token(user) do
    changeset = AuthToken.changeset(%AuthToken{}, user)
    auth_token = Repo.insert!(changeset)
    auth_token.value
  end
end
