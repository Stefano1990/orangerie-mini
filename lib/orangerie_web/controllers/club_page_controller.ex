defmodule OrangerieWeb.ClubPageController do
  use OrangerieWeb, :controller

  alias OrangerieWeb.ClubPages

  def index(conn, _params) do
    render(conn, :index, pages: ClubPages.all())
  end

  def show(conn, %{"slug" => slug}) do
    case ClubPages.get(slug) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(html: OrangerieWeb.ErrorHTML)
        |> render(:"404")

      page ->
        render(conn, :show,
          page: page,
          siblings: Enum.reject(ClubPages.all(), &(&1.slug == slug)),
          next_page: ClubPages.next(slug)
        )
    end
  end
end
