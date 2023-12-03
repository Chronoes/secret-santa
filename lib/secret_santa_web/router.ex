defmodule SecretSantaWeb.Router do
  use SecretSantaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_root_layout, html: {SecretSantaWeb.Layouts, :root}
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SecretSantaWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/privacy", PrivacyController, :privacy

    post "/wish", WishController, :change_wish
    post "/wish/pool", WishController, :create_pool
    post "/wish/emails", WishController, :send_emails
  end

  scope "/auth", SecretSantaWeb do
    pipe_through :browser

    get "/", AuthController, :login_index
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/identity/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", SecretSantaWeb do
  #   pipe_through :api
  # end
end
