defmodule SecretSantaWeb.Router do
  use SecretSantaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
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
    get "/login/:id", AuthController, :login
    post "/login/:id", AuthController, :auth

    post "/wish", WishController, :change_wish
    post "/wish/pool", WishController, :create_pool
  end

  # Other scopes may use custom stacks.
  # scope "/api", SecretSantaWeb do
  #   pipe_through :api
  # end
end
