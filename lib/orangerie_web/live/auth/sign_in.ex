defmodule OrangerieWeb.Live.Auth.SignIn do
  use OrangerieWeb, :live_view
  alias OrangerieWeb.Components.PrelineComponents, as: Preline

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <main class="mx-auto grid max-w-5xl items-center gap-16 px-6 py-16 md:py-24 lg:grid-cols-2">
        <!-- ========== ANMELDEN ========== -->
        <div class="mx-auto w-full max-w-md">
          <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">
            Mitgliederbereich
          </p>
          <h1 class="mt-4 font-display text-4xl md:text-5xl">Willkommen zurück.</h1>
          <p class="mt-4 leading-relaxed text-muted">
            Melde dich mit deinem Passwort an oder lass dir einen
            Magic Link an deine E-Mail senden.
          </p>

          <nav
            class="mt-10 flex rounded-full border border-gold/25 bg-base-200/60 p-1"
            aria-label="Anmeldemethode"
            role="tablist"
            aria-orientation="horizontal"
          >
            <button
              type="button"
              id="sign-in-tab-password"
              class="active flex grow basis-0 cursor-pointer items-center justify-center gap-2 rounded-full px-4 py-2 text-sm text-muted transition-colors hover:text-primary focus:outline-hidden hs-tab-active:bg-base-100 hs-tab-active:text-primary hs-tab-active:shadow-sm"
              data-hs-tab="#sign-in-panel-password"
              aria-controls="sign-in-panel-password"
              aria-selected="true"
              role="tab"
            >
              <Preline.icon name="lock" class="size-4 shrink-0" /> Passwort
            </button>
            <button
              type="button"
              id="sign-in-tab-magic-link"
              class="flex grow basis-0 cursor-pointer items-center justify-center gap-2 rounded-full px-4 py-2 text-sm text-muted transition-colors hover:text-primary focus:outline-hidden hs-tab-active:bg-base-100 hs-tab-active:text-primary hs-tab-active:shadow-sm"
              data-hs-tab="#sign-in-panel-magic-link"
              aria-controls="sign-in-panel-magic-link"
              aria-selected="false"
              role="tab"
            >
              <Preline.icon name="sparkles" class="size-4 shrink-0" /> Magic Link
            </button>
          </nav>

          <div>
            <h3><strong>testing</strong></h3>
            <p>
              Bitte mit "foobar@foobar.com" und "foobar123" einloggen.
              <strong>Bitte den Benutzer nicht löcshen :)</strong>
            </p>
          </div>
          <div
            id="sign-in-panel-password"
            role="tabpanel"
            aria-labelledby="sign-in-tab-password"
          >
            <.form
              for={@sign_in_with_password_form}
              class="mt-8 space-y-6"
              phx-submit="sign-in-with-password"
            >
              <Preline.input
                field={@sign_in_with_password_form[:email]}
                type="email"
                label="E-Mail"
                placeholder="name@beispiel.ch"
                autocomplete="email"
                required
                tabindex="1"
              />
              <Preline.input
                field={@sign_in_with_password_form[:password]}
                label="Passwort"
                autocomplete="current-password"
                type="password"
                required
                tabindex="2"
              >
                <:label_action>
                  <a
                    href={~p"/passwort-vergessen"}
                    class="text-sm text-muted transition-colors hover:text-primary focus:text-primary focus:outline-hidden"
                  >
                    Passwort vergessen?
                  </a>
                </:label_action>
              </Preline.input>
              <Preline.button class="w-full" type="submit">
                Anmelden
              </Preline.button>
            </.form>
          </div>

          <div
            id="sign-in-panel-magic-link"
            class="hidden"
            role="tabpanel"
            aria-labelledby="sign-in-tab-magic-link"
          >
            <!--
            <form id="sign-in-magic-link-form" class="mt-8 space-y-6">
              <Preline.form_input
                id="sign-in-magic-link-email"
                name="email"
                type="email"
                label="E-Mail"
                placeholder="name@beispiel.ch"
                autocomplete="email"
                required
              />
              <p class="flex items-start gap-2.5 text-sm leading-relaxed text-gold">
                <Preline.icon name="mail" class="mt-0.5 size-4 shrink-0" />
                Kein Passwort nötig: Wir senden dir einen einmaligen
                Anmeldelink an deine E-Mail-Adresse.
              </p>
              <button
                type="submit"
                class="w-full cursor-pointer rounded-full bg-primary px-8 py-3 text-[15px] tracking-wide text-primary-content shadow-lg shadow-primary/40 transition-colors hover:bg-primary/90 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-gold"
              >
                Link senden
              </button>
            </form>
            -->
          </div>

          <p class="mt-10 border-t border-base-300 pt-6 text-center text-sm text-muted">
            Noch kein Konto?
            <a
              href={~p"/registrieren"}
              class="text-primary underline decoration-gold/60 decoration-1 underline-offset-4 transition-colors hover:decoration-gold focus:outline-hidden focus:decoration-gold"
            >
              Jetzt registrieren
            </a>
          </p>
        </div>
        <!-- ========== END ANMELDEN ========== -->

        <!-- ========== BOGENFENSTER ========== -->
        <div class="hidden lg:flex lg:justify-center">
          <figure
            data-theme="dark"
            class="relative aspect-[4/5] w-full max-w-sm overflow-hidden rounded-t-full rounded-b-2xl border border-gold/30 bg-base-100"
          >
            <img
              src="https://orangerie-prod.s3.eu-central-1.amazonaws.com/static_pages/welcome/lounge2.jpg"
              alt="Die lange Bar der Orangerie im Kerzenlicht"
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
              <p class="font-script text-4xl text-gold">Bis gleich.</p>
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
    sign_in_with_password_form =
      Orangerie.Accounts.form_to_sign_in_with_password(
        context: %{
          token_type: :sign_in
        }
      )
      |> to_form()

    socket =
      assign(socket,
        page_title: "Anmelden",
        sign_in_with_password_form: sign_in_with_password_form
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("sign-in-with-password", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.sign_in_with_password_form,
           params: form_params,
           read_one?: true
         ) do
      {:ok, user} ->
        {:noreply,
         redirect(socket,
           to:
             ~p"/auth/user/password/sign_in_with_token?#{[token: user.__metadata__.token, return_to: ~p"/users/#{user.slug}"]}"
         )}

      {:error, form} ->
        {:noreply, assign(socket, sign_in_with_password_form: form)}
    end
  end
end
