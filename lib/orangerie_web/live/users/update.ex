defmodule OrangerieWeb.Live.Users.Update do
  use OrangerieWeb, :live_view

  on_mount {OrangerieWeb.LiveUserAuth, :live_user_required}

  @impl true
  def render(assigns) do
    ~H"""
    {inspect(@user)}
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    user = Orangerie.Accounts.get_user_by_slug!(slug, actor: socket.assigns.current_user)
    {:ok, assign(socket, user: user)}
  end
end
