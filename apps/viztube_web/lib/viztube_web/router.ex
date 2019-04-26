defmodule ViztubeWeb.Router do
  use ViztubeWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug ViztubeWeb.GuardianAuthPipeline
    plug ViztubeWeb.Plug.CurrentUser
  end

  pipeline :browser_ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ViztubeWeb do
    pipe_through [:browser, :browser_auth]
    get "/signin/:token", SessionController, :show, as: :signin
    get "/sessions", SessionController, :new
    post "/sessions", SessionController, :create
  end


  scope "/", ViztubeWeb do
    pipe_through [:browser, :browser_auth, :browser_ensure_auth] # Use the default browser stack

    get "/", PageController, :index
    post "/search", PageController, :search

    delete "/sessions", SessionController, :delete

    get "/users", UserController, :index
    post "/users", UserController, :create
    get "/users/confirm-delete/:id", UserController, :delete_confirmation
    delete "/users/:id", UserController, :delete

    get "/queries", QueryController, :index
    get "/queries/:id", QueryController, :show
    get "/queries/confirm-delete/:id", QueryController, :delete_confirmation
    delete "/queries/:id", QueryController, :delete

    get "/tags/:id", TagController, :show
    #  TODO: review this !
    get "/tags/:tag_name/delete-confirmation", TagController, :delete_confirmation
    delete "/tags/:tag_name", TagController, :delete
    post "/tags/:tag_id/remove/:channel_id", TagController, :delete_tag

    get "/channels", ChannelController, :index
    post "/channels", ChannelController, :create
    post "/channels/:id", ChannelController, :show
    get "/channels/:id", ChannelController, :show
    put "/channels/:channel_id/add", ChannelController, :add_tag
    get "/channels/confirm-delete/:id", ChannelController, :delete_confirmation
    delete "/channels/:id", ChannelController, :delete

  end

  # Other scopes may use custom stacks.
  # scope "/api", ViztubeWeb do
  #   pipe_through :api
  # end
end
