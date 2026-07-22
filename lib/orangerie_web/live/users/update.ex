defmodule OrangerieWeb.Live.Users.Update do
  use OrangerieWeb, :live_view
  alias OrangerieWeb.Components.PrelineComponents, as: Preline

  on_mount {OrangerieWeb.LiveUserAuth, :live_user_required}

  @type_options [
    {"Frau", :f},
    {"Mann", :m},
    {"Paar (Frau & Mann)", :mf},
    {"Paar (Frau & Frau)", :ff},
    {"Paar (Mann & Mann)", :mm}
  ]

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_user={@current_user}>
      <main class="mx-auto w-full max-w-xl px-6 py-16 md:py-24">
        <!-- ========== KONTO ========== -->
        <p class="text-[11px] font-medium uppercase tracking-[0.35em] text-muted">
          Mitgliederbereich
        </p>
        <h1 class="mt-4 font-display text-4xl md:text-5xl">Dein Konto.</h1>
        <p class="mt-4 leading-relaxed text-muted">
          Angemeldet als <span class="text-primary">{@user.username}</span>
          — hier passt du dein Profil an und änderst dein Passwort.
        </p>

        <.form for={@form} class="mt-12 space-y-10" phx-submit="submit">
          <.section
            title="Profil"
            subtitle="Wie du im Club auftrittst — sichtbar bei Reservationen und Gästelisten."
          >
            <Preline.input
              field={@form[:type]}
              type="select"
              label="Profil-Typ"
              prompt="Bitte wählen"
              options={@type_options}
              required
              tabindex="1"
            />
          </.section>

          <.section
            title="Passwort"
            subtitle="Leer lassen, wenn du dein aktuelles Passwort behalten möchtest."
          >
            <Preline.input
              field={@form[:password]}
              type="password"
              label="Neues Passwort"
              autocomplete="new-password"
              placeholder="Mindestens 8 Zeichen"
              tabindex="2"
            />
            <Preline.input
              field={@form[:password_confirmation]}
              type="password"
              label="Neues Passwort bestätigen"
              autocomplete="new-password"
              tabindex="3"
            />
          </.section>
          <Preline.button type="submit">
            Änderungen speichern
          </Preline.button>
        </.form>

        <!-- ========== KONTO LÖSCHEN ========== -->
        <section class="mt-16 border-t border-base-300 pt-8">
          <h2 class="font-display text-2xl">Konto löschen</h2>
          <p class="mt-2 text-sm leading-relaxed text-muted">
            Dein Konto und alle damit verbundenen Daten werden dauerhaft
            entfernt. Dieser Schritt kann nicht rückgängig gemacht werden.
          </p>
          <.form for={nil} action={~p"/users/destroy"} method="delete">
            <Preline.button
              type="submit"
              style="danger"
              class="mt-6 px-6 py-2.5"
              data-confirm="Are you sure?"
            >
              Konto unwiderruflich löschen
            </Preline.button>
          </.form>
        </section>
        <!-- ========== END KONTO ========== -->
      </main>
    </Layouts.app>
    """
  end

  @doc false
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  slot :inner_block, required: true

  defp section(assigns) do
    ~H"""
    <section class="border-t border-base-300 pt-8">
      <h2 class="font-display text-2xl">{@title}</h2>
      <p :if={@subtitle} class="mt-1 text-sm text-muted">{@subtitle}</p>
      <div class="mt-6 space-y-6">
        {render_slot(@inner_block)}
      </div>
    </section>
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    user = Orangerie.Accounts.get_user_by_slug!(slug, actor: socket.assigns.current_user)

    socket =
      socket
      |> assign(user: user)
      |> assign(type_options: @type_options)
      |> assign(page_title: "Dein Konto")
      |> assign_form()

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form,
           params: form_params,
           actor: socket.assigns.current_user
         ) do
      {:ok, _user} ->
        socket =
          socket
          |> put_flash(:info, "Profile updated")
          |> assign_form()

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  @impl true
  def handle_event("destroy", _payload, socket) do
    case Orangerie.Accounts.destroy_user(socket.assigns.user, actor: socket.assigns.current_user) do
      :ok ->
        socket =
          socket
          |> put_flash(:info, "Account deleted")
          |> redirect(to: ~p"/")

        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  defp assign_form(socket) do
    form =
      Orangerie.Accounts.form_to_update_user(socket.assigns.user,
        actor: socket.assigns.current_user
      )
      |> to_form()

    assign(socket, form: form)
  end
end
