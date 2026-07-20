defmodule Orangerie.Accounts do
  use Ash.Domain,
    otp_app: :orangerie,
    extensions: [AshPhoenix]

  resources do
    resource Orangerie.Accounts.Token

    resource Orangerie.Accounts.User do
      define :register_user_with_password,
        args: [:email, :username, :password, :password_confirmation],
        action: :register_with_password

      define :sign_in_with_password
      define :get_user_by_slug, action: :read, get_by: [:slug]
    end
  end
end
