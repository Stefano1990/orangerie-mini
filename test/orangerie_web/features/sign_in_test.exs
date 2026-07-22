defmodule OrangerieWeb.Features.SignInTest do
  use OrangerieWeb.ConnCase, async: true

  test "I can sign in", %{conn: conn} do
    user =
      Orangerie.Accounts.register_user_with_password!(
        "foobar@foobar.com",
        "foobar",
        "foobar123",
        "foobar123", actor: nil)

    conn
    |> visit(~p"/anmelden")
    |> fill_in("E-Mail", with: "foobar@foobar.com")
    |> fill_in("Passwort", with: "foobar123")
    |> click_button("Anmelden")
    |> assert_path(~p"/users/#{user.slug}")
  end
end
