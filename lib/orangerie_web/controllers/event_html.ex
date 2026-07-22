defmodule OrangerieWeb.EventHTML do
  @moduledoc """
  This module contains pages rendered by EventController, plus the
  event-specific components (event card, guest chip, review card).

  See the `event_html` directory for all templates available.
  """
  use OrangerieWeb, :html

  embed_templates "event_html/*"

  @weekday_names {"Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"}
  @month_names {"Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August",
                "September", "Oktober", "November", "Dezember"}

  @doc """
  Renders one event as a card for the index grid, linking to its show page.
  Passed evenings (`past`) keep their place in the grid but fade behind a
  grey overlay.
  """
  attr :event, :map, required: true
  attr :past, :boolean, default: false

  def event_card(assigns) do
    ~H"""
    <article class={["group", @past && "opacity-75 transition-opacity hover:opacity-100"]}>
      <a href={~p"/events/#{@event.id}"} class="block focus:outline-hidden">
        <div
          data-theme="dark"
          class="relative aspect-[4/5] overflow-hidden rounded-t-full rounded-b-2xl border border-gold/30 bg-base-100 transition-colors duration-500 group-hover:border-gold/70 group-focus-visible:border-gold"
        >
          <img
            src={@event.image}
            alt={@event.image_alt}
            loading="lazy"
            class={[
              "absolute inset-0 size-full object-cover motion-safe:transition-transform motion-safe:duration-700 motion-safe:group-hover:scale-105",
              @past && "grayscale"
            ]}
          />
          <div
            :if={@past}
            class="absolute inset-0 bg-base-100/45"
            aria-hidden="true"
          >
          </div>
          <div
            class="absolute inset-0 bg-linear-to-t from-base-100/90 via-base-100/10 to-base-100/35"
            aria-hidden="true"
          >
          </div>
          <div
            class="pointer-events-none absolute inset-2 rounded-t-full rounded-b-xl border border-base-content/10"
            aria-hidden="true"
          >
          </div>
          <div :if={@past} class="absolute inset-x-0 top-10 flex justify-center">
            <span class="rounded-full border border-base-content/25 bg-base-100/60 px-3 py-1 text-[10px] uppercase tracking-[0.25em] text-base-content/80 backdrop-blur-sm">
              Vorbei
            </span>
          </div>
          <div class="absolute inset-x-0 bottom-0 p-6 text-center text-base-content">
            <p class={["font-display text-xl", (@past && "text-muted") || "text-gold"]}>
              {format_date_short(@event.date)} · {format_time(@event.time)} Uhr
            </p>
            <h3 class="mt-1 font-display text-2xl">{@event.title}</h3>
          </div>
        </div>

        <p class="mt-4 px-2 text-center text-sm leading-relaxed text-muted line-clamp-3">
          {@event.description}
        </p>
        <p class="mt-3 text-center text-xs uppercase tracking-[0.2em] text-muted/80">
          {guest_summary(@event.guests)}
        </p>
      </a>
    </article>
    """
  end

  @doc """
  Renders a whole month of events as a collapsible Preline accordion item:
  a toggle row with month name and event count, and the events as compact
  rows inside. Meant to live in an `hs-accordion-group` container.
  """
  attr :id_prefix, :string, required: true, doc: "namespaces the DOM ids per accordion group"
  attr :month, Date, required: true
  attr :events, :list, required: true
  attr :open, :boolean, default: false

  def month_accordion(assigns) do
    assigns =
      assign(assigns, :id, "#{assigns.id_prefix}-#{Calendar.strftime(assigns.month, "%Y-%m")}")

    ~H"""
    <div class={["hs-accordion", @open && "active"]} id={@id}>
      <button
        type="button"
        class="hs-accordion-toggle group/toggle flex w-full items-baseline justify-between gap-6 border-b border-base-300 py-5 text-start focus:outline-hidden"
        aria-expanded={to_string(@open)}
        aria-controls={"#{@id}-content"}
      >
        <span class="font-display text-2xl transition-colors group-hover/toggle:text-primary group-focus-visible/toggle:text-primary">
          {format_month(@month)}
        </span>
        <span class="flex shrink-0 items-center gap-3 text-xs uppercase tracking-[0.2em] text-muted/80">
          {length(@events)} Abende
          <.icon
            name="hero-chevron-down-mini"
            class="size-4 text-gold transition-transform duration-300 hs-accordion-active:rotate-180"
          />
        </span>
      </button>

      <div
        id={"#{@id}-content"}
        class={[
          "hs-accordion-content w-full overflow-hidden transition-[height] duration-300",
          !@open && "hidden"
        ]}
        role="region"
        aria-labelledby={@id}
      >
        <ul class="ps-2 md:ps-6">
          <.event_row :for={event <- @events} event={event} />
        </ul>
      </div>
    </div>
    """
  end

  @doc """
  Renders one event as a compact row (date, title, guest summary), linking
  to its show page. Used inside the month accordions.
  """
  attr :event, :map, required: true

  def event_row(assigns) do
    ~H"""
    <li>
      <a
        href={~p"/events/#{@event.id}"}
        class="group flex flex-wrap items-baseline gap-x-6 gap-y-1 border-b border-base-300 py-4 focus:outline-hidden sm:flex-nowrap"
      >
        <span class="w-44 shrink-0 text-sm text-muted">{format_date(@event.date)}</span>
        <span class="grow font-display text-xl transition-colors group-hover:text-primary group-focus-visible:text-primary">
          {@event.title}
        </span>
        <span class="shrink-0 text-xs uppercase tracking-[0.2em] text-muted/80">
          {guest_summary(@event.guests)}
        </span>
      </a>
    </li>
    """
  end

  @doc """
  Renders one guest as a chip: initials, username and type (Paar/Single).
  """
  attr :guest, :map, required: true

  def guest_chip(assigns) do
    ~H"""
    <li class="flex items-center gap-3 rounded-full border border-base-300 bg-base-100/60 px-4 py-2.5">
      <span
        class="flex size-9 shrink-0 items-center justify-center rounded-full border border-gold/40 bg-base-200 font-display text-sm text-gold"
        aria-hidden="true"
      >
        {initials(@guest.username)}
      </span>
      <span class="min-w-0">
        <span class="block truncate text-sm">{@guest.username}</span>
        <span class="block text-[11px] uppercase tracking-[0.2em] text-muted">
          {guest_type_label(@guest.type)}
        </span>
      </span>
    </li>
    """
  end

  @doc """
  Advertises the welcome-drink perk: reservations made at least 24 hours
  before the evening starts come with a drink on the house.
  """
  attr :deadline, NaiveDateTime, required: true
  attr :active, :boolean, required: true

  def free_drink_banner(assigns) do
    ~H"""
    <div
      data-theme="dark"
      class="flex items-start gap-5 rounded-2xl border border-gold/40 bg-base-200 p-6 text-base-content md:p-8"
    >
      <span
        class="flex size-12 shrink-0 items-center justify-center rounded-full border border-gold/50 text-gold"
        aria-hidden="true"
      >
        <OrangerieWeb.Components.PrelineComponents.icon name="wine" class="size-6" />
      </span>
      <div>
        <p class="font-script text-2xl text-gold">Ein Glas aufs Haus</p>
        <p class="mt-2 leading-relaxed text-muted">
          Wer mindestens 24 Stunden im Voraus reserviert, wird mit einem
          Willkommensdrink begrüsst.
          <span :if={@active} class="text-base-content">
            Für diesen Abend gilt das noch bis {format_datetime(@deadline)}.
          </span>
          <span :if={!@active}>
            Für diesen Abend ist die Frist leider verstrichen. Der nächste
            kommt bestimmt.
          </span>
        </p>
      </div>
    </div>
    """
  end

  @doc """
  The reservation area of the show page: a reservation form for logged-in
  members, otherwise a call to action to sign in or become a member.
  """
  attr :event, :map, required: true
  attr :member, :map, default: nil, doc: "the logged-in member, or nil"

  def reservation_box(assigns) do
    ~H"""
    <.form
      :if={@member}
      for={%{}}
      action={~p"/events/#{@event.id}/reserve"}
      class="rounded-2xl border border-base-300 bg-base-100/60 p-6 md:p-8"
    >
      <div class="border-b border-base-300 pb-5">
        <.member_identity member={@member} label="Reservation als" />
      </div>

      <button
        type="submit"
        class="mt-6 w-full rounded-full bg-primary px-8 py-3 text-[15px] tracking-wide text-primary-content transition-colors hover:bg-primary/90 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gold"
      >
        Reservieren
      </button>
    </.form>

    <div
      :if={is_nil(@member)}
      class="rounded-2xl border border-base-300 bg-base-100/60 p-8 text-center md:p-10"
    >
      <p class="font-display text-2xl">Reservationen sind Mitgliedern vorbehalten.</p>
      <p class="mx-auto mt-3 max-w-sm leading-relaxed text-muted">
        Melde dich an, um deinen Platz für diesen Abend zu reservieren —
        oder lerne das Haus als Mitglied kennen.
      </p>
      <div class="mt-8 flex flex-wrap items-center justify-center gap-4">
        <a
          href="#"
          class="rounded-full bg-primary px-8 py-3 text-[15px] tracking-wide text-primary-content transition-colors hover:bg-primary/90 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gold"
        >
          Anmelden
        </a>
        <a
          href="#"
          class="rounded-full border border-gold/50 px-8 py-3 text-[15px] tracking-wide transition-colors hover:border-gold focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gold"
        >
          Mitglied werden
        </a>
      </div>
    </div>
    """
  end

  @doc """
  Feedback form for a past evening: star rating plus a few words, submitted
  by the logged-in member. The stars are plain radio inputs — rendered in
  reverse DOM order and flipped back with `flex-row-reverse`, so the CSS
  sibling selector `:checked ~ label` can fill every star up to the chosen
  one without JavaScript.
  """
  attr :event, :map, required: true
  attr :member, :map, required: true

  def review_form(assigns) do
    ~H"""
    <.form
      for={%{}}
      action={~p"/events/#{@event.id}/review"}
      class="max-w-xl rounded-2xl border border-base-300 bg-base-100/60 p-6 md:p-8"
    >
      <p class="font-display text-2xl">Wie war der Abend?</p>
      <div class="mt-4 border-b border-base-300 pb-5">
        <.member_identity member={@member} label="Bewertung als" />
      </div>

      <fieldset class="mt-6">
        <legend class="text-xs uppercase tracking-[0.2em] text-muted">Deine Bewertung</legend>
        <div class="mt-2 flex flex-row-reverse justify-end gap-1">
          <%= for n <- 5..1//-1 do %>
            <input
              type="radio"
              id={"rating-#{n}"}
              name="review[rating]"
              value={n}
              checked={n == 5}
              class="sr-only"
            />
            <label
              for={"rating-#{n}"}
              class="cursor-pointer rounded-sm text-base-300 transition-colors hover:text-gold/70 [:checked~&]:text-gold [:focus-visible+&]:outline-2 [:focus-visible+&]:outline-offset-2 [:focus-visible+&]:outline-gold"
            >
              <.icon name="hero-star-solid" class="size-7" />
              <span class="sr-only">{n} von 5 Sternen</span>
            </label>
          <% end %>
        </div>
      </fieldset>

      <label class="mt-6 block">
        <span class="text-xs uppercase tracking-[0.2em] text-muted">Deine Worte</span>
        <textarea
          name="review[text]"
          rows="4"
          required
          placeholder="Diskret bleiben — keine Namen, nur das Gefühl des Abends."
          class="mt-2 w-full rounded-xl border border-base-300 bg-base-100 px-4 py-3 placeholder:text-muted/60 focus:border-gold focus:outline-hidden"
        ></textarea>
      </label>

      <button
        type="submit"
        class="mt-7 w-full rounded-full bg-primary px-8 py-3 text-[15px] tracking-wide text-primary-content transition-colors hover:bg-primary/90 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gold"
      >
        Bewertung senden
      </button>
      <p class="mt-4 text-center text-xs text-muted">
        Deine Stimme erscheint bei den künftigen Abenden der Serie «{@event.series}».
      </p>
    </.form>
    """
  end

  @doc """
  The logged-in member with initials avatar, e.g. "Reservation als Nachtfalter_Duo (Paar)".
  """
  attr :member, :map, required: true
  attr :label, :string, required: true

  def member_identity(assigns) do
    ~H"""
    <div class="flex items-center gap-3">
      <span
        class="flex size-9 shrink-0 items-center justify-center rounded-full border border-gold/40 bg-base-200 font-display text-sm text-gold"
        aria-hidden="true"
      >
        {initials(@member.username)}
      </span>
      <p class="text-sm text-muted">
        {@label}
        <span class="font-medium text-base-content">{@member.username}</span>
        ({guest_type_label(@member.type)})
      </p>
    </div>
    """
  end

  @doc """
  Renders a review from an earlier edition of the event's series.
  """
  attr :review, :map, required: true

  def review_card(assigns) do
    ~H"""
    <blockquote class="flex flex-col rounded-2xl border border-base-300 bg-base-100/60 p-6">
      <div class="flex items-center justify-between gap-4">
        <cite class="text-sm font-medium not-italic">{@review.username}</cite>
        <.stars rating={@review.rating} />
      </div>
      <p class="mt-3 grow leading-relaxed text-muted">«{@review.text}»</p>
      <p class="mt-5 text-[11px] uppercase tracking-[0.2em] text-muted/80">
        Ausgabe vom {format_date_short(@review.event_date)}
      </p>
    </blockquote>
    """
  end

  @doc """
  Renders a 1–5 star rating in gold.
  """
  attr :rating, :integer, required: true

  def stars(assigns) do
    ~H"""
    <div class="flex shrink-0 items-center gap-0.5" aria-label={"#{@rating} von 5 Sternen"}>
      <.icon
        :for={i <- 1..5}
        name="hero-star-solid"
        class={["size-3.5", if(i <= @rating, do: "text-gold", else: "text-base-300")]}
      />
    </div>
    """
  end

  def format_date(date) do
    "#{weekday_name(date)}, #{format_date_short(date)}"
  end

  def format_date_short(date) do
    "#{date.day}. #{elem(@month_names, date.month - 1)} #{date.year}"
  end

  def format_time(time), do: Calendar.strftime(time, "%H:%M")

  def format_datetime(naive) do
    "#{format_date(NaiveDateTime.to_date(naive))}, #{format_time(NaiveDateTime.to_time(naive))} Uhr"
  end

  def format_month(date), do: "#{month_name(date)} #{date.year}"

  def month_name(date), do: elem(@month_names, date.month - 1)

  defp weekday_name(date), do: elem(@weekday_names, Date.day_of_week(date) - 1)

  def guest_type_label(:couple), do: "Paar"
  def guest_type_label(:single), do: "Single"

  def guest_summary(guests) do
    couples = Enum.count(guests, &(&1.type == :couple))
    singles = length(guests) - couples
    "#{couples} Paare · #{singles} Singles"
  end

  defp initials(username) do
    username
    |> String.split(~r/[\s_\-.&]+/, trim: true)
    |> Enum.take(2)
    |> Enum.map_join(&String.first/1)
    |> String.upcase()
  end
end
