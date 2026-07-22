defmodule OrangerieWeb.EventController do
  use OrangerieWeb, :controller

  # Dummy data until events get a real context. The club runs three evenings
  # per week (Thursday, Friday, Saturday), so events are generated from the
  # weekly rhythm below — a handful of weeks into the past and future relative
  # to today. Reviews are collected per series (from earlier editions), not
  # per single event.

  @lounge "https://orangerie-prod.s3.eu-central-1.amazonaws.com/static_pages/welcome"

  # A Monday anchoring the rotation of the Friday/Saturday series.
  @epoch ~D[2026-01-05]
  @weeks_back 6
  # Events are published at least six months in advance.
  @weeks_ahead 26

  @series %{
    "Ladies Night" => %{
      slug: "ladies-night",
      time: ~T[19:00:00],
      editions: [],
      image: "#{@lounge}/lounge2.jpg",
      image_alt: "Die beleuchtete Bar mit Barhockern unter der Galerie",
      description:
        "Der Donnerstag gehört den Damen: Prosecco-Empfang an der Bar, kleine " <>
          "Verwöhnkarte aus der Küche und später Musik im Salon. Einzelne Damen " <>
          "und Paare sind willkommen — die Herren an diesem Abend nur in Begleitung."
    },
    "Fire & Ice" => %{
      slug: "fire-and-ice",
      time: ~T[21:00:00],
      editions: [],
      image: "#{@lounge}/lounge5.jpg",
      image_alt: "Der grosse Salon mit Ledersofas und Marmortischen unter der Galerie",
      description:
        "Eisgekühlte Drinks an der Bar, offenes Feuer in der Gartenhütte und um " <>
          "Mitternacht eine Show zwischen beiden Elementen. Wer dabei war, " <>
          "erzählt es niemandem. Versprochen."
    },
    "Salon Rouge" => %{
      slug: "salon-rouge",
      time: ~T[21:00:00],
      editions: ["Jazz am Kamin", "Nuit de Piano", "Chanson-Nacht"],
      image: "#{@lounge}/lounge3.jpg",
      image_alt: "Séparée mit Louis-XV-Sofas und Kerzenlicht an oxblutroter Wand",
      description:
        "Der Freitag im Zeichen des roten Salons: ein Pianist am Flügel, Chansons " <>
          "bis Mitternacht und Kerzen auf jeder Brüstung. Der Dresscode verlangt " <>
          "wenig — nur einen Hauch von Rot."
    },
    "Bal Masqué" => %{
      slug: "bal-masque",
      time: ~T[20:00:00],
      editions: ["Sommernacht", "Venezianische Nacht", "Mitternachtsball", "Nuit Blanche"],
      image: "#{@lounge}/lounge4.jpg",
      image_alt: "Der grosse Saal mit Kronleuchtern und Bogenfenstern, bereit für den Ball",
      description:
        "Eine Nacht hinter venezianischen Masken: Apéro an der langen Bar, " <>
          "Dinner bei Kerzenlicht und um Mitternacht die grosse Show auf dem Catwalk. " <>
          "Die Maske fällt erst, wenn du es willst — oder gar nicht. Masken liegen " <>
          "am Empfang bereit, elegante Abendgarderobe in Schwarz ist Ehrensache."
    },
    "Dîner en Blanc" => %{
      slug: "diner-en-blanc",
      time: ~T[19:30:00],
      editions: [],
      image: "#{@lounge}/lounge4.jpg",
      image_alt: "Der grosse Saal mit Kronleuchtern, gedeckt für die lange weisse Tafel",
      description:
        "Die Orangerie deckt eine lange weisse Tafel unter den Bogenfenstern. " <>
          "Fünf Gänge, weisse Garderobe von Kopf bis Fuss und nach dem Dessert " <>
          "offenes Feuer im Garten — bis die letzte Kerze heruntergebrannt ist."
    }
  }

  # Simulated session until real auth lands. The show page assumes this
  # member is logged in; append ?gast=1 to preview the logged-out state.
  @current_member %{username: "Nachtfalter_Duo", type: :couple}

  @guest_pool [
    %{username: "Nachtfalter_Duo", type: :couple},
    %{username: "LadyVelours", type: :single},
    %{username: "SamtUndSeide", type: :couple},
    %{username: "Monsieur_C", type: :single},
    %{username: "Funkenflug_TG", type: :couple},
    %{username: "Mademoiselle_J", type: :single},
    %{username: "ZweiVonUns", type: :couple},
    %{username: "GoldeneStunde", type: :couple},
    %{username: "Herzdame_ZH", type: :single},
    %{username: "Wintergartenpaar", type: :couple},
    %{username: "Seidenherz", type: :single},
    %{username: "LaContessa", type: :single},
    %{username: "Abendrot_Duo", type: :couple},
    %{username: "PerlenUndGin", type: :single},
    %{username: "GenussPaar_TG", type: :couple},
    %{username: "EisUndFeuer", type: :couple}
  ]

  # Reviews keyed by series name — written after earlier editions of the same
  # series. The edition each review refers to is attached at request time from
  # the actual past occurrences.
  @reviews %{
    "Bal Masqué" => [
      %{
        username: "GoldeneStunde",
        rating: 5,
        text:
          "Unser erster Ball in der Orangerie — vom ersten Glas bis zum Feuer " <>
            "im Garten hat einfach alles gestimmt."
      },
      %{
        username: "Nachtfalter_Duo",
        rating: 5,
        text:
          "Hinter der Maske fällt das Ankommen leicht. Die Show um Mitternacht " <>
            "war das Eleganteste, was wir seit Jahren gesehen haben."
      },
      %{
        username: "Monsieur_C",
        rating: 4,
        text:
          "Grossartige Küche, wunderbare Stimmung. Einzig die Gästeliste war " <>
            "schnell voll — früh anmelden lohnt sich."
      }
    ],
    "Ladies Night" => [
      %{
        username: "Seidenherz",
        rating: 5,
        text:
          "Als einzelne Dame selten habe ich mich irgendwo so wohl gefühlt. " <>
            "Aufmerksames Haus, null Aufdringlichkeit."
      },
      %{
        username: "Abendrot_Duo",
        rating: 4,
        text:
          "Entspannter Donnerstag mit hervorragenden Drinks. Der Salon war " <>
            "gegen Mitternacht das Wohnzimmer, das man nicht verlassen will."
      }
    ],
    "Fire & Ice" => [
      %{
        username: "EisUndFeuer",
        rating: 5,
        text:
          "Der Moment, in dem die Show vom Eis ans Feuer wechselt, ist jedes " <>
            "Mal wieder Gänsehaut. Wir haben uns nach diesem Abend benannt."
      }
    ],
    "Dîner en Blanc" => [
      %{
        username: "Wintergartenpaar",
        rating: 5,
        text:
          "Die weisse Tafel unter den Bogenfenstern ist jedes Mal der schönste " <>
            "Abend des Monats. Wir kommen seit der ersten Ausgabe."
      }
    ]
  }

  # The current month is always shown in full (its passed evenings greyed
  # out); months further ahead and the archive collapse into accordions.
  def index(conn, _params) do
    today = Date.utc_today()

    {past_months, rest} =
      Enum.split_while(events(today), &(month_key(&1.date) < month_key(today)))

    {this_month, later} = Enum.split_while(rest, &(month_key(&1.date) == month_key(today)))

    render(conn, :index,
      today: today,
      this_month: this_month,
      later_by_month: group_by_month(later),
      past_by_month: group_by_month(Enum.reverse(past_months))
    )
  end

  def show(conn, %{"id" => id} = params) do
    today = Date.utc_today()

    case Enum.find(events(today), &(&1.id == id)) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(html: OrangerieWeb.ErrorHTML)
        |> render(:"404")

      event ->
        render(conn, :show,
          event: event,
          past?: Date.compare(event.date, today) == :lt,
          reviews: reviews_for(event.series, today),
          current_member: if(params["gast"], do: nil, else: @current_member),
          drink_deadline: drink_deadline(event),
          drink_available?: drink_available?(event)
        )
    end
  end

  def reserve(conn, %{"id" => id}) do
    today = Date.utc_today()
    event = Enum.find(events(today), &(&1.id == id))

    cond do
      is_nil(event) ->
        conn
        |> put_status(:not_found)
        |> put_view(html: OrangerieWeb.ErrorHTML)
        |> render(:"404")

      Date.compare(event.date, today) == :lt ->
        conn
        |> put_flash(:error, "Dieser Abend liegt bereits hinter uns.")
        |> redirect(to: ~p"/events/#{event.id}")

      true ->
        message =
          if drink_available?(event) do
            "Reserviert — dein Willkommensdrink wartet an der Bar. Wir freuen uns auf dich."
          else
            "Reserviert. Wir freuen uns auf dich."
          end

        conn
        |> put_flash(:info, message)
        |> redirect(to: ~p"/events/#{event.id}")
    end
  end

  # All events, chronologically ascending, spanning the configured window of
  # weeks around today.
  defp events(today) do
    monday = Date.beginning_of_week(today)

    for week_offset <- -@weeks_back..@weeks_ahead,
        week_start = Date.add(monday, week_offset * 7),
        {series, date, occurrence} <- week_slots(week_start) do
      build_event(series, date, occurrence)
    end
  end

  # Three slots per week: Ladies Night every Thursday, Fridays alternating
  # between Fire & Ice and Salon Rouge, Saturdays between Bal Masqué and
  # Dîner en Blanc. `occurrence` counts how often the series has run and
  # drives the rotation of its edition names.
  defp week_slots(week_start) do
    week_index = div(Date.diff(week_start, @epoch), 7)

    [
      {"Ladies Night", Date.add(week_start, 3), week_index},
      {rotate(["Fire & Ice", "Salon Rouge"], week_index), Date.add(week_start, 4),
       div(week_index, 2)},
      {rotate(["Bal Masqué", "Dîner en Blanc"], week_index + 1), Date.add(week_start, 5),
       div(week_index + 1, 2)}
    ]
  end

  defp build_event(series_name, date, occurrence) do
    series = Map.fetch!(@series, series_name)

    title =
      case series.editions do
        [] -> series_name
        editions -> "#{series_name} — #{rotate(editions, occurrence)}"
      end

    %{
      id: "#{series.slug}-#{Date.to_iso8601(date)}",
      title: title,
      series: series_name,
      date: date,
      time: series.time,
      image: series.image,
      image_alt: series.image_alt,
      description: series.description,
      guests: guests_for(series.slug, date)
    }
  end

  # Deterministic per-event slice of the guest pool, so a given evening always
  # shows the same guest list.
  defp guests_for(slug, date) do
    seed = :erlang.phash2({slug, date})
    count = 5 + Integer.mod(seed, 6)

    @guest_pool
    |> rotate_by(Integer.mod(seed, length(@guest_pool)))
    |> Enum.take(count)
  end

  # The series' reviews, each attributed to one of the most recent past
  # editions (two reviews per edition).
  defp reviews_for(series_name, today) do
    past_dates =
      events(today)
      |> Enum.filter(&(&1.series == series_name and Date.compare(&1.date, today) == :lt))
      |> Enum.map(& &1.date)
      |> Enum.reverse()

    @reviews
    |> Map.get(series_name, [])
    |> Enum.with_index()
    |> Enum.map(fn {review, i} ->
      Map.put(review, :event_date, Enum.at(past_dates, div(i, 2)) || Date.add(today, -7))
    end)
  end

  # Chunks a chronologically ordered event list into `{month_date, events}`
  # tuples, preserving the incoming order (ascending or descending).
  defp group_by_month(events) do
    events
    |> Enum.chunk_by(&{&1.date.year, &1.date.month})
    |> Enum.map(fn [first | _] = month_events -> {first.date, month_events} end)
  end

  def review(conn, %{"id" => id} = params) do
    today = Date.utc_today()
    event = Enum.find(events(today), &(&1.id == id))
    text = params |> get_in(["review", "text"]) |> to_string() |> String.trim()

    cond do
      is_nil(event) ->
        conn
        |> put_status(:not_found)
        |> put_view(html: OrangerieWeb.ErrorHTML)
        |> render(:"404")

      Date.compare(event.date, today) != :lt ->
        conn
        |> put_flash(:error, "Bewerten kannst du einen Abend, sobald er hinter uns liegt.")
        |> redirect(to: ~p"/events/#{event.id}")

      text == "" ->
        conn
        |> put_flash(:error, "Ein paar Worte hätten wir gerne — deine Bewertung war noch leer.")
        |> redirect(to: ~p"/events/#{event.id}")

      true ->
        conn
        |> put_flash(
          :info,
          "Vielen Dank für deine Stimme! Nach einem kurzen Blick der Gastgeber erscheint sie bei der Serie."
        )
        |> redirect(to: ~p"/events/#{event.id}")
    end
  end

  # Reservations made at least 24 hours before an evening starts come with a
  # complimentary welcome drink.
  defp drink_deadline(event) do
    event.date
    |> NaiveDateTime.new!(event.time)
    |> NaiveDateTime.add(-24, :hour)
  end

  defp drink_available?(event) do
    NaiveDateTime.compare(NaiveDateTime.utc_now(), drink_deadline(event)) == :lt
  end

  defp month_key(date), do: {date.year, date.month}

  defp rotate(list, i), do: Enum.at(list, Integer.mod(i, length(list)))

  defp rotate_by(list, n), do: Enum.drop(list, n) ++ Enum.take(list, n)
end
