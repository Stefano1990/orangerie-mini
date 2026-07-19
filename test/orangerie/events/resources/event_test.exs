defmodule Orangerie.Test.Events.Resources.EvenTTest do
  use Orangerie.DataCase, async: true
  alias Orangerie.Events

  setup do
    event_series =
      Events.create_event_series!(%{
        name: %{de: "foobar", fr: "foobar"},
        allowed_profile_types: [:m, :mf]
      })

    valid_params = %{
      event_series: event_series.id,
      title: %{
        de: "foobar title",
        fr: "foobaz title"
      },
      date: ~D[2026-01-01],
      start_time: ~T[19:00:00],
      description: %{
        de: "foobar desc",
        fr: "foobaz desc"
      }
    }

    %{
      event_series: event_series,
      valid_params: valid_params
    }
  end

  test "it generates the slug correctly", %{valid_params: valid_params} do
    event = Events.create_event!(valid_params)

    assert event.slug == "foobar-title-2026-1-1"
  end

  test "calculates past? correctly", %{valid_params: valid_params} do
    upcoming_params = Map.put(valid_params, :date, ~D[2100-01-01])
    past_params = Map.put(valid_params, :date, ~D[2000-01-01])
    today_params = Map.put(valid_params, :date, Date.utc_today())

    upcoming_event = Events.create_event!(upcoming_params)
    refute upcoming_event.past?

    past_event = Events.create_event!(past_params)
    assert past_event.past?

    today_event = Events.create_event!(today_params)
    refute today_event.past?
  end

  test "list_events_of_the_current_month", %{valid_params: valid_params} do
    beginning_of_month = Date.utc_today() |> Date.beginning_of_month()
    params = Map.put(valid_params, :date, beginning_of_month)
    distance_future_params = Map.put(valid_params, :date, ~D[2100-01-01])
    event1 = Events.create_event!(params)
    _event2 = Events.create_event!(distance_future_params)

    assert [event1.id] == Enum.map(Events.list_events_of_current_month!(), & &1.id)
  end
end
