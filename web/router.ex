defmodule Notereal.Router do
  use Notereal.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
  end

  scope "/", Notereal do
    # pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/tags", TagController, except: [:new, :edit]
    resources "/posts", PostController, except: [:new, :edit]
    post "users/login", UserController, :login
  end

  # Other scopes may use custom stacks.
  # scope "/api", Notereal do
  #   pipe_through :api
  # end
end
