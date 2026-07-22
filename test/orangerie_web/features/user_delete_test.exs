defmodule OrangerieWeb.Features.UserDeleteTest do
  use OrangerieWeb.ConnCase, async: true

  test "I can delete my user", %{conn: conn} do
    user = Orangerie.Accounts.register_user_with_password!("foobar@foobar.com", "foobar", "foobar123", "foobar123")

    conn
    |> visit(~p"/anmelden")
    |> fill_in("E-Mail", with: "foobar@foobar.com")
    |> fill_in("Passwort", with: "foobar123")
    |> click_button("Anmelden")
    |> assert_path(~p"/users/#{user.slug}")
    |> click_button("Konto unwiderruflich löschen")
    |> assert_path(~p"/")

    assert 0 = Ash.count!(Orangerie.Accounts.User, authorize?: false)
  end
end
