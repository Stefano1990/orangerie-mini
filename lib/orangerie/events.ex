defmodule Orangerie.Events do
  use Ash.Domain, otp_app: :orangerie, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Orangerie.Events.EventSeries do
      define :create_event_series, action: :create
    end

    resource Orangerie.Events.Event do
      define :create_event, action: :create
      define :get_event_by_slug, action: :read, get_by: [:slug]
      define :list_events, action: :read
      define :list_events_of_current_month, action: :current_month
      define :list_events_for_year_and_month, action: :for_year_and_month, args: [:year, :month]
    end
  end
end
