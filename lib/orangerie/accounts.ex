defmodule Orangerie.Accounts do
  use Ash.Domain,
    otp_app: :orangerie

  resources do
    resource Orangerie.Accounts.Token
    resource Orangerie.Accounts.User
  end
end
