defmodule LunchboxApiWeb.Router do
  use LunchboxApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LunchboxApiWeb do
    pipe_through :api

    resources "/foods", FoodController, except: [:new, :edit]
  end
end
