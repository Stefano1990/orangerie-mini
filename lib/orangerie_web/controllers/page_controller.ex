defmodule OrangerieWeb.PageController do
  use OrangerieWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
