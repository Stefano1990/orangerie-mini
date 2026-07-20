defmodule OrangerieWeb.Live.Auth.SignUp do
  use OrangerieWeb, :live_view
  alias OrangerieWeb.Components.PrelineComponents, as: Preline

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <main class="mx-auto grid max-w-5xl items-center gap-16 px-6 py-16 md:py-24 lg:grid-cols-2">
        <!-- ========== REGISTRIEREN ========== -->
        <div class="mx-auto w-full max-w-md">
          <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">
            Mitglied werden
          </p>
          <h1 class="mt-4 font-display text-4xl md:text-5xl">Treten Sie ein.</h1>
          <p class="mt-4 leading-relaxed text-muted">
            Ihr Konto für Reservationen und Neuigkeiten aus dem Haus. Was Sie
            uns anvertrauen, bleibt bei uns — diskret wie alles in der
            Orangerie.
          </p>

          <.form
            for={@register_form}
            class="mt-10 space-y-6"
            phx-change="validate"
            phx-submit="submit"
          >
            <Preline.input
              field={@register_form[:email]}
              type="email"
              label="E-Mail"
              placeholder="name@beispiel.ch"
              autocomplete="email"
              required
            />
            <Preline.input
              field={@register_form[:username]}
              label="Username"
              required
            />
            <Preline.input
              field={@register_form[:password]}
              label="Passwort"
              autocomplete="new-password"
              required
              type="password"
            />
            <Preline.input
              field={@register_form[:password_confirmation]}
              label="Passwort bestätigen"
              autocomplete="new-password"
              type="password"
              required
            />
            <p class="flex items-start gap-2.5 text-sm leading-relaxed text-gold">
              <Preline.icon name="mail" class="mt-0.5 size-4 shrink-0" />
              Nach der Registration erhalten Sie eine E-Mail, um Ihre Adresse
              zu bestätigen.
            </p>
            <button
              type="submit"
              class="w-full cursor-pointer rounded-full bg-primary px-8 py-3 text-[15px] tracking-wide text-primary-content shadow-lg shadow-primary/40 transition-colors hover:bg-primary/90 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gold"
            >
              Konto erstellen
            </button>
          </.form>

          <p class="mt-6 text-center text-xs uppercase tracking-[0.2em] text-muted/80">
            Zutritt ab 18 Jahren · Elegante Abendgarderobe
          </p>

          <p class="mt-10 border-t border-base-300 pt-6 text-center text-sm text-muted">
            Bereits Mitglied?
            <a
              href={~p"/anmelden"}
              class="text-primary underline decoration-gold/60 decoration-1 underline-offset-4 transition-colors hover:decoration-gold focus:outline-hidden focus:decoration-gold"
            >
              Anmelden
            </a>
          </p>
        </div>
        <!-- ========== END REGISTRIEREN ========== -->

        <!-- ========== BOGENFENSTER ========== -->
        <div class="hidden lg:flex lg:justify-center">
          <figure
            data-theme="dark"
            class="relative aspect-[4/5] w-full max-w-sm overflow-hidden rounded-t-full rounded-b-2xl border border-gold/30 bg-base-100"
          >
            <img
              src="https://orangerie-prod.s3.eu-central-1.amazonaws.com/static_pages/welcome/lounge5.jpg"
              alt="Der grosse Salon der Orangerie"
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
              <p class="font-script text-4xl text-gold">Wir freuen uns.</p>
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
    register_form = Orangerie.Accounts.form_to_register_user_with_password()

    socket =
      assign(
        socket,
        register_form: register_form |> to_form(),
        page_title: "Registrieren"
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => form_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.register_form, form_params) |> to_form()
    {:noreply, assign(socket, register_form: form)}
  end

  @impl true
  def handle_event("submit", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.register_form, params: form_params) do
      {:ok, user} ->
        dbg(user)
        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, register_form: form)}
    end
  end
end
