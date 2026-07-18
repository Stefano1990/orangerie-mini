defmodule OrangerieWeb.Live.Events.Show do
  use OrangerieWeb, :live_view
  alias Orangerie.Embedded.TranslatedField

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <main class="mx-auto max-w-6xl px-6 py-16 md:py-24">
        <a
          href={~p"/events"}
          class="text-sm text-muted transition-colors hover:text-primary focus:text-primary focus:outline-hidden"
        >
          &larr; Alle Events
        </a>

        <!-- ========== EVENT ========== -->
        <section class="mt-10 grid items-center gap-12 md:grid-cols-2 lg:gap-16">
          <div
            data-theme="dark"
            class="relative mx-auto w-full max-w-72 md:max-w-96 aspect-[4/5] overflow-hidden rounded-t-full rounded-b-2xl border border-gold/30 bg-base-100"
          >
            <!--
            <img
              src={@event.image}
              alt={@event.image_alt}
              class="absolute inset-0 size-full object-cover"
            />
            -->
            <div
              class="pointer-events-none absolute inset-2 rounded-t-full rounded-b-xl border border-base-content/10"
              aria-hidden="true"
            >
            </div>
          </div>

          <div>
            <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">
              {TranslatedField.translate(@event.event_series.name)}
            </p>
            <h1 class="mt-4 font-display text-4xl leading-[1.1] md:text-5xl">
              {TranslatedField.translate(@event.title)}
            </h1>

            <p class="mt-8 font-display text-2xl text-gold">
              {Localize.Date.to_string!(@event.date, format: :full)}
            </p>
            <p class="mt-1 text-muted">
              {if @event.past?, do: "Einlass war ab", else: "Einlass ab"}
              {Localize.Time.to_string!(@event.start_time, format: :short)} Uhr
            </p>
            <p :if={@event.past?} class="mt-2 text-sm italic text-muted">
              Dieser Abend liegt hinter uns.
            </p>

            <p class="mt-8 max-w-xl leading-relaxed text-muted">
              {TranslatedField.translate(@event.description)}
            </p>

            <div class="mt-10 flex flex-wrap items-center gap-4">
              <a
                :if={!@event.past?}
                href="#reservieren"
                class="rounded-full bg-primary px-8 py-3 text-[15px] tracking-wide text-primary-content transition-colors hover:bg-primary/90 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gold"
              >
                Jetzt reservieren
              </a>
              <a
                href="#gaeste"
                class="rounded-full border border-gold/50 px-8 py-3 text-[15px] tracking-wide transition-colors hover:border-gold focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gold"
              >
                Zur Gästeliste
              </a>
            </div>
          </div>
        </section>
        <!-- ========== END EVENT ========== -->

        <!-- ========== RESERVATION ========== -->
        <section :if={!@event.past?} id="reservieren" class="scroll-mt-24 pt-20 md:pt-28">
          <div class="grid items-start gap-10 lg:grid-cols-2 lg:gap-16">
            <div>
              <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">
                Reservation
              </p>
              <h2 class="mt-4 font-display text-3xl md:text-4xl">Ihr Platz an diesem Abend.</h2>
              <p class="mt-4 max-w-xl leading-relaxed text-muted">
                Eine Reservation genügt — für den Rest sorgt das Haus. Ihr Name
                erscheint danach auf der Gästeliste dieses Abends.
              </p>

              <div class="mt-8">
                <.free_drink_banner event={@event} active={not @event.past?} />
              </div>
            </div>

            <!--<.reservation_box event={@event} member={@current_member} />-->
          </div>
        </section>
        <!-- ========== END RESERVATION ========== -->

        <!-- ========== GÄSTELISTE ========== -->
        <!--
        <section id="gaeste" class="scroll-mt-24 pt-20 md:pt-28">
          <div class="flex flex-wrap items-end justify-between gap-4">
            <div>
              <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">
                Gästeliste
              </p>
              <h2 class="mt-4 font-display text-3xl md:text-4xl">
                {if @past?, do: "Wer dabei war.", else: "Wer dabei ist."}
              </h2>
            </div>
            <p class="text-sm uppercase tracking-[0.2em] text-muted/80">
              {guest_summary(@event.guests)}
            </p>
          </div>

          <ul class="mt-10 grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            <.guest_chip :for={guest <- @event.guests} guest={guest} />
          </ul>

          <p class="mt-8 text-sm italic text-muted">
            Aus Diskretion zeigen wir nur Mitgliedsnamen — nie mehr.
          </p>
        </section>
        -->
        <!-- ========== END GÄSTELISTE ========== -->

        <!-- ========== STIMMEN ZUR SERIE ========== -->
        <!--
        <section class="pt-20 md:pt-28">
          <div class="max-w-2xl">
            <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">Stimmen</p>
            <h2 class="mt-4 font-display text-3xl md:text-4xl">
              Gäste über «{@event.series}».
            </h2>
            <p class="mt-4 leading-relaxed text-muted">
              Bewertungen aus früheren Ausgaben dieser Serie.
            </p>
          </div>

          <div :if={@reviews != []} class="mt-10 grid gap-5 md:grid-cols-2 lg:grid-cols-3">
            <.review_card :for={review <- @reviews} review={review} />
          </div>

          <p :if={@reviews == []} class="mt-10 italic text-muted">
            Noch keine Stimmen zu dieser Serie — vielleicht schreiben Sie die erste.
          </p>

          <div :if={@past? && @current_member} class="mt-14">
            <.review_form event={@event} member={@current_member} />
          </div>

          <p :if={@past? && is_nil(@current_member)} class="mt-10 text-sm text-muted">
            <a href="#" class="text-primary transition-colors hover:underline">Melden Sie sich an</a>,
            um diesen Abend zu bewerten.
          </p>
        </section>
        -->
        <!-- ========== END STIMMEN ========== -->
      </main>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    event = Orangerie.Events.get_event_by_slug!(slug, load: :event_series)
    socket = assign(socket, event: event)

    {:ok, socket}
  end

  @doc """
  Advertises the welcome-drink perk: reservations made at least 24 hours
  before the evening starts come with a drink on the house.
  """
  attr :event, Orangerie.Events.Event, required: true
  attr :active, :boolean, required: true

  def free_drink_banner(assigns) do
    deadline =
      DateTime.new!(assigns.event.date, assigns.event.start_time) |> DateTime.shift(hour: -24)

    assigns = assign(assigns, deadline: deadline, now: DateTime.utc_now())

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
          <span :if={@now <= @deadline} class="text-base-content">
            Für diesen Abend gilt das noch bis {Localize.DateTime.to_string!(@deadline)}.
          </span>
          <span :if={!@active}>
            Für diesen Abend ist die Frist leider verstrichen — der nächste
            kommt bestimmt.
          </span>
        </p>
      </div>
    </div>
    """
  end
end
