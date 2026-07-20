defmodule OrangerieWeb.Live.Auth.ResetPassword do
  use OrangerieWeb, :live_view
  alias OrangerieWeb.Components.PrelineComponents, as: Preline

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <main class="mx-auto grid max-w-5xl items-center gap-16 px-6 py-16 md:py-24 lg:grid-cols-2">
        <!-- ========== PASSWORT VERGESSEN ========== -->
        <div class="mx-auto w-full max-w-md">
          <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">
            Passwort vergessen
          </p>
          <h1 class="mt-4 font-display text-4xl md:text-5xl">Halb so schlimm.</h1>
          <p class="mt-4 leading-relaxed text-muted">
            Geben Sie die E-Mail-Adresse Ihres Kontos ein. Wir senden Ihnen
            einen Link, mit dem Sie in Ruhe ein neues Passwort setzen.
          </p>

          <form id="reset-password-form" class="mt-10 space-y-6">
            <Preline.form_input
              id="reset-password-email"
              name="email"
              type="email"
              label="E-Mail"
              placeholder="name@beispiel.ch"
              autocomplete="email"
              required
            />
            <p class="flex items-start gap-2.5 text-sm leading-relaxed text-gold">
              <Preline.icon name="mail" class="mt-0.5 size-4 shrink-0" />
              Der Link ist aus Sicherheitsgründen nur kurze Zeit gültig.
            </p>
            <button
              type="submit"
              class="w-full cursor-pointer rounded-full bg-primary px-8 py-3 text-[15px] tracking-wide text-primary-content shadow-lg shadow-primary/40 transition-colors hover:bg-primary/90 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gold"
            >
              Link anfordern
            </button>
          </form>

          <p class="mt-10 border-t border-base-300 pt-6 text-center text-sm text-muted">
            Doch wieder eingefallen?
            <a
              href={~p"/anmelden"}
              class="text-primary underline decoration-gold/60 decoration-1 underline-offset-4 transition-colors hover:decoration-gold focus:outline-hidden focus:decoration-gold"
            >
              Zur Anmeldung
            </a>
          </p>
        </div>
        <!-- ========== END PASSWORT VERGESSEN ========== -->

        <!-- ========== BOGENFENSTER ========== -->
        <div class="hidden lg:flex lg:justify-center">
          <figure
            data-theme="dark"
            class="relative aspect-[4/5] w-full max-w-sm overflow-hidden rounded-t-full rounded-b-2xl border border-gold/30 bg-base-100"
          >
            <img
              src="https://orangerie-prod.s3.eu-central-1.amazonaws.com/static_pages/welcome/lounge3.jpg"
              alt="Ein ruhiges Séparée der Orangerie"
              class="absolute inset-0 size-full object-cover"
            />
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
            <figcaption class="absolute inset-x-0 bottom-0 p-10 text-center">
              <p class="font-script text-4xl text-gold">Kommt vor.</p>
            </figcaption>
          </figure>
        </div>
        <!-- ========== END BOGENFENSTER ========== -->
      </main>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Passwort vergessen")}
  end
end
