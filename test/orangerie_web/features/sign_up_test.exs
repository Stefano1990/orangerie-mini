defmodule OrangerieWeb.Features.SignUpTest do
  use OrangerieWeb.ConnCase

  test "I can sign up", %{conn: conn} do
    conn
    |> visit(~p"/registrieren")
    |> fill_in("E-Mail", with: "foobar@foobar.com")
    |> fill_in("Username", with: "foobar")
    |> fill_in("Passwort", with: "foobar123")
    |> fill_in("Passwort bestätigen", with: "foobar123")
    |> click_button("Konto erstellen")
    |> assert_path(~p"/")

    assert %Orangerie.Accounts.User{} =
             Orangerie.Accounts.get_user_by_slug!("foobar", authorize?: false)
  end
end
