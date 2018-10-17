defmodule Notereal.PageController do
  use Notereal.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
