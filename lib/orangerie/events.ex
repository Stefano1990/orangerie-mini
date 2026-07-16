defmodule Orangerie.Events do
  use Ash.Domain, otp_app: :orangerie, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Orangerie.Events.EventSeries
  end
end
