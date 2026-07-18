defmodule OrangerieWeb.Live.Events.Index do
  use OrangerieWeb, :live_view
  alias Orangerie.Events
  alias Orangerie.Embedded.TranslatedField

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <main class="mx-auto max-w-6xl px-6 py-16 md:py-24">
        <!-- ========== DER LAUFENDE MONAT ========== -->
        <div class="max-w-2xl">
          <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">
            Eventkalender
          </p>
          <h1 class="mt-4 font-display text-4xl md:text-5xl">
            {Localize.Date.to_string!(@today, format: "MMM")} in der Orangerie.
          </h1>
          <p class="mt-5 text-lg leading-relaxed text-muted">
            Donnerstag, Freitag, Samstag — drei Abende pro Woche, jeder mit eigenem
            Thema und eigener Gästeliste. Der ganze Monat auf einen Blick, auch die
            Abende, die schon Geschichte sind.
          </p>
          <p class="mt-4 flex items-center gap-2.5 text-gold">
            <OrangerieWeb.Components.PrelineComponents.icon name="wine" class="size-4 shrink-0" />
            Früh reserviert, gut begrüsst: Bei Reservation bis 24 Stunden vor dem
            Abend ist der Willkommensdrink geschenkt.
          </p>
        </div>

        <div class="mt-14 grid gap-x-6 gap-y-16 sm:grid-cols-2 lg:grid-cols-3">
          <.event_card
            :for={event <- @events}
            event={event}
          />
        </div>
        <!-- ========== END DER LAUFENDE MONAT ========== -->

          <!-- ========== WEITER IM KALENDER ========== -->
        <section class="pt-24 md:pt-32">
          <div class="max-w-2xl">
            <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">Vorschau</p>
            <h2 class="mt-4 font-display text-3xl md:text-4xl">Weiter im Kalender.</h2>
            <p class="mt-4 leading-relaxed text-muted">
              Wir publizieren unsere Abende mindestens sechs Monate im Voraus —
              ab dem nächsten Monat jeweils zum Aufklappen.
            </p>
          </div>

          <div class="hs-accordion-group mt-10 border-t border-base-300">
            <.month_accordion
              :for={i <- 1..12}
              id_prefix="vorschau"
              i={i}
              today={@today}
            />
          </div>
        </section>
        <!-- ========== END WEITER IM KALENDER ========== -->

          <!-- ========== VERGANGENE ABENDE ========== -->
        <section class="pt-24 md:pt-32">
          <div class="max-w-2xl">
            <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">Archiv</p>
            <h2 class="mt-4 font-display text-3xl md:text-4xl">Vergangene Abende.</h2>
            <p class="mt-4 leading-relaxed text-muted">
              Was war, bleibt im Haus — aber die Abende selbst dürfen Sie gerne
              noch einmal nachlesen.
            </p>
          </div>

          <div class="hs-accordion-group mt-10 border-t border-base-300">
            <.month_accordion
              :for={i <- -1..-12//-1}
              id_prefix="archiv"
              i={i}
              today={@today}
              order={:desc}
            /> -->
          </div>
        </section>
        <!-- ========== END VERGANGENE ABENDE ========== -->
      </main>
    </Layouts.app>
    <code>
      {inspect(@events)}
    </code>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    events = Events.list_events_of_current_month!()

    socket =
      assign(
        socket,
        events: events,
        today: Date.utc_today()
      )

    {:ok, socket}
  end

  @doc """
  Renders one event as a card for the index grid, linking to its show page.
  Passed evenings (`past`) keep their place in the grid but fade behind a
  grey overlay.
  """
  attr :event, Events.Event, required: true

  def event_card(assigns) do
    ~H"""
    <article class={["group", @event.past? && "opacity-75 transition-opacity hover:opacity-100"]}>
      <a href={~p"/events/#{@event.id}"} class="block focus:outline-hidden">
        <div
          data-theme="dark"
          class="relative aspect-[4/5] overflow-hidden rounded-t-full rounded-b-2xl border border-gold/30 bg-base-100 transition-colors duration-500 group-hover:border-gold/70 group-focus-visible:border-gold"
        >
          <!--
          <img
            src={@event.image}
            alt={@event.image_alt}
            loading="lazy"
            class={[
              "absolute inset-0 size-full object-cover motion-safe:transition-transform motion-safe:duration-700 motion-safe:group-hover:scale-105",
              @past && "grayscale"
            ]}
          />
          -->
          <div
            :if={@event.past?}
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
          <div :if={@event.past?} class="absolute inset-x-0 top-10 flex justify-center">
            <span class="rounded-full border border-base-content/25 bg-base-100/60 px-3 py-1 text-[10px] uppercase tracking-[0.25em] text-base-content/80 backdrop-blur-sm">
              Vorbei
            </span>
          </div>
          <div class="absolute inset-x-0 bottom-0 p-6 text-center text-base-content">
            <p class={["font-display text-xl", (@event.past? && "text-muted") || "text-gold"]}>
              {Localize.Date.to_string!(@event.date, format: :long)} · {Localize.Time.to_string!(
                @event.start_time,
                format: :short
              )} Uhr
            </p>
            <h3 class="mt-1 font-display text-2xl">{TranslatedField.translate(@event.title)}</h3>
          </div>
        </div>

        <p class="mt-4 px-2 text-center text-sm leading-relaxed text-muted line-clamp-3">
          {TranslatedField.translate(@event.description)}
        </p>
        <p class="mt-3 text-center text-xs uppercase tracking-[0.2em] text-muted/80">
          <!--{guest_summary(@event.guests)}-->
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
  attr :i, :integer, required: true
  attr :today, Date, required: true
  attr :open, :boolean, default: false
  attr :order, :atom, values: [:asc, :desc], default: :asc

  def month_accordion(assigns) do
    desired_year_and_month = Date.shift(assigns.today, month: assigns.i)

    events =
      Orangerie.Events.list_events_for_year_and_month!(
        desired_year_and_month.year,
        desired_year_and_month.month,
        %{order: assigns.order}
      )

    assigns =
      assign(
        assigns,
        id: "#{assigns.id_prefix}-#{assigns.i}",
        events: events,
        desired_year_and_month: desired_year_and_month
      )

    ~H"""
    <div class={["hs-accordion", @open && "active"]} id={@id}>
      <button
        type="button"
        class="hs-accordion-toggle cursor-pointer group/toggle flex w-full items-baseline justify-between gap-6 border-b border-base-300 py-5 text-start focus:outline-hidden"
        aria-expanded={to_string(@open)}
        aria-controls={"#{@id}-content"}
      >
        <span class="font-display text-2xl transition-colors group-hover/toggle:text-primary group-focus-visible/toggle:text-primary">
          {Localize.Date.to_string!(@desired_year_and_month, format: "MMMM yyyy")}
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
        href={~p"/events/#{@event.slug}"}
        class="group flex flex-wrap items-baseline gap-x-6 gap-y-1 border-b border-base-300 py-4 focus:outline-hidden sm:flex-nowrap"
      >
        <span class="w-44 shrink-0 text-sm text-muted">{Localize.Date.to_string!(@event.date,
          format: :full
        )}</span>
        <span class="grow font-display text-xl transition-colors group-hover:text-primary group-focus-visible:text-primary">
          {TranslatedField.translate(@event.title)}
        </span>
        <span class="shrink-0 text-xs uppercase tracking-[0.2em] text-muted/80"><!--{guest_summary(@event.guests)}--></span>
      </a>
    </li>
    """
  end
end
