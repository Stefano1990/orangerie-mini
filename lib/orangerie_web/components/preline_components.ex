defmodule OrangerieWeb.Components.PrelineComponents do
  @moduledoc """
  Preline-based UI components.

  The `header/1` component renders a classic responsive navbar. It is composed
  of a handful of small building blocks (`nav_link/1`, `collapse_button/1` and
  `icon/1`) so the markup stays readable and the repeated pieces live in one
  place.
  """
  use Phoenix.Component
  use OrangerieWeb, :verified_routes

  @doc """
  Renders the classic Preline header/navbar.
  """
  def header(assigns) do
    ~H"""
    <!-- ========== HEADER ========== -->
    <header class="sticky top-0 z-50 w-full flex flex-wrap md:justify-start md:flex-nowrap border-b border-gold/25 bg-base-100/80 backdrop-blur-md">
      <nav class="relative max-w-[85rem] w-full md:flex md:items-center md:justify-between md:gap-3 mx-auto px-4 sm:px-6 lg:px-8 py-2">
        <!-- Logo w/ Collapse Button -->
        <div class="flex items-center justify-between">
          <a
            class="flex-none focus:outline-hidden focus:opacity-80"
            href="#"
            aria-label="Orangerie le Club"
          >
            <img
              src="https://orangerie.eu/images/logo_small.png"
              alt="Orangerie le Club"
              class="h-11 w-auto"
            />
          </a>

          <.collapse_button />
        </div>
        <!-- End Logo w/ Collapse Button -->

    <!-- Collapse -->
        <div
          id="hs-header-classic"
          class="hs-collapse hidden overflow-hidden transition-all duration-300 basis-full grow md:block md:overflow-visible"
          aria-labelledby="hs-header-classic-collapse"
          role="region"
        >
          <!-- The scroll clipping is only for the opened mobile menu; on desktop it
               must stay visible so the "Das Haus" dropdown can overlay the page -->
          <div class="overflow-hidden overflow-y-auto max-h-[75vh] md:max-h-none md:overflow-visible [&::-webkit-scrollbar]:w-2 [&::-webkit-scrollbar-thumb]:rounded-full [&::-webkit-scrollbar-track]:bg-base-200 [&::-webkit-scrollbar-thumb]:bg-base-300">
            <div class="py-2 md:py-0 flex flex-col md:flex-row md:items-center md:justify-end gap-0.5 md:gap-1">
              <.haus_dropdown />
              <.nav_link href="/#abend" icon="wine">Der Abend</.nav_link>
              <.nav_link href={~p"/events"} icon="calendar">Events</.nav_link>
              <.nav_link href="/#etikette" icon="heart">Etikette</.nav_link>
              <.nav_link href="/#kontakt" icon="map-pin">Kontakt</.nav_link>

              <!-- Button Group -->
              <div class="relative flex flex-wrap items-center gap-x-1.5 md:ps-2.5 mt-1 md:mt-0 md:ms-1.5 before:block before:absolute before:top-1/2 before:-inset-s-px before:w-px before:h-4 before:bg-base-300 before:-translate-y-1/2">
                <a
                  class="p-2 px-4 w-full flex items-center justify-center rounded-full border border-primary/40 text-sm text-primary hover:bg-primary hover:text-primary-content focus:outline-hidden focus:bg-primary focus:text-primary-content transition-colors"
                  href={~p"/anmelden"}
                >
                  <.icon name="user" class="shrink-0 size-4 me-3 md:me-2" /> Anmelden
                </a>
              </div>
              <!-- End Button Group -->
            </div>
          </div>
        </div>
        <!-- End Collapse -->
      </nav>
    </header>
    <!-- ========== END HEADER ========== -->
    """
  end

  @doc """
  Mobile hamburger button that toggles the collapsible navigation.
  """
  def collapse_button(assigns) do
    ~H"""
    <div class="md:hidden">
      <button
        type="button"
        class="hs-collapse-toggle relative size-9 flex justify-center items-center text-sm rounded-full bg-base-100 border border-base-300 text-base-content hover:bg-base-200 focus:outline-hidden focus:bg-base-200 disabled:opacity-50 disabled:pointer-events-none"
        id="hs-header-classic-collapse"
        aria-expanded="false"
        aria-controls="hs-header-classic"
        aria-label="Toggle navigation"
        data-hs-collapse="#hs-header-classic"
      >
        <.icon name="menu" class="hs-collapse-open:hidden size-4" />
        <.icon name="close" class="hs-collapse-open:block shrink-0 hidden size-4" />
        <span class="sr-only">Toggle navigation</span>
      </button>
    </div>
    """
  end

  @doc """
  "Das Haus" navigation dropdown, listing the overview plus every club page
  from `OrangerieWeb.ClubPages`. Follows Preline's documented "navbar with
  dropdown" pattern (adapted to our `md:` breakpoint): static, inline
  accordion inside the collapsed menu on mobile; Floating-UI positioned
  (`--strategy:fixed` with adaptive positioning) below the trigger on
  desktop.
  """
  def haus_dropdown(assigns) do
    ~H"""
    <div class="hs-dropdown [--strategy:static] md:[--strategy:fixed] [--adaptive:none] md:[--adaptive:adaptive]">
      <button
        id="hs-haus-dropdown"
        type="button"
        class="hs-dropdown-toggle cursor-pointer flex w-full items-center p-2 text-[15px] text-base-content/75 transition-colors hover:text-primary focus:text-primary focus:outline-hidden"
        aria-haspopup="menu"
        aria-expanded="false"
        aria-label="Das Haus"
      >
        <.icon name="home" class="shrink-0 size-4 me-3 md:me-2 block md:hidden" /> Das Haus
        <.icon
          name="chevron-down"
          class="ms-auto size-4 shrink-0 duration-300 hs-dropdown-open:rotate-180 md:ms-1.5"
        />
      </button>

      <div
        class="hs-dropdown-menu hidden top-full z-10 rounded-xl p-1 ps-8 opacity-0 transition-[opacity,margin] duration-150 ease-in-out before:absolute before:-top-5 before:start-0 before:h-5 before:w-full hs-dropdown-open:opacity-100 md:w-56 md:border md:border-base-300 md:bg-base-100 md:p-1.5 md:shadow-lg md:shadow-base-content/10"
        role="menu"
        aria-orientation="vertical"
        aria-labelledby="hs-haus-dropdown"
      >
        <a
          class="flex rounded-lg px-3 py-2 text-[15px] text-base-content/75 transition-colors hover:bg-base-200 hover:text-primary focus:bg-base-200 focus:text-primary focus:outline-hidden"
          href={~p"/haus"}
        >
          Der Rundgang
        </a>
        <div class="my-1.5 hidden h-px bg-base-300 md:block" aria-hidden="true"></div>
        <a
          :for={page <- OrangerieWeb.ClubPages.all()}
          class="flex rounded-lg px-3 py-2 text-[15px] text-base-content/75 transition-colors hover:bg-base-200 hover:text-primary focus:bg-base-200 focus:text-primary focus:outline-hidden"
          href={~p"/haus/#{page.slug}"}
        >
          {page.title}
        </a>
      </div>
    </div>
    """
  end

  @doc """
  A top-level navigation link with a leading icon (visible on mobile only).
  """
  attr :href, :string, default: "#"
  attr :icon, :string, required: true
  attr :active, :boolean, default: false
  slot :inner_block, required: true

  def nav_link(assigns) do
    ~H"""
    <a
      class={[
        "p-2 flex items-center text-[15px] transition-colors focus:outline-hidden",
        @active &&
          "text-primary font-medium underline decoration-gold decoration-1 underline-offset-[6px]",
        !@active && "text-base-content/75 hover:text-primary focus:text-primary"
      ]}
      href={@href}
      aria-current={@active && "page"}
    >
      <.icon name={@icon} class="shrink-0 size-4 me-3 md:me-2 block md:hidden" />
      {render_slot(@inner_block)}
    </a>
    """
  end

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
               search select tel text textarea time url week hidden)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :class, :any, default: nil, doc: "the input class to use over defaults"
  attr :error_class, :any, default: nil, doc: "the input error class to use over defaults"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  slot :label_action

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(assigns = %{type: "password"}) do
    assigns = assign(assigns, :toggle_opts, ~s({"target": "##{assigns.id}"}))

    ~H"""
    <div>
      <div class="mb-2 flex items-baseline justify-between gap-4">
        <label for={@id} class="block text-sm">{@label}</label>
        {render_slot(@label_action)}
      </div>
      <div class="relative">
        <input
          type="password"
          id={@id}
          name={@name}
          class={[input_classes(@errors), "pe-12"]}
          aria-invalid={@errors != [] && "true"}
          aria-describedby={@errors != [] && "#{@id}-error"}
          {@rest}
        />
        <button
          type="button"
          data-hs-toggle-password={@toggle_opts}
          class="absolute inset-y-0 end-0 z-10 flex cursor-pointer items-center px-4 text-muted transition-colors hover:text-primary focus:text-primary focus:outline-hidden"
          aria-label="Passwort anzeigen oder verbergen"
        >
          <.icon name="eye" class="size-4 shrink-0 hs-password-active:hidden" />
          <.icon name="eye-off" class="hidden size-4 shrink-0 hs-password-active:block" />
        </button>
      </div>
      <.error :for={msg <- @errors} id={"#{@id}-error"}>{msg}</.error>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div>
      <div class="mb-2 flex items-baseline justify-between gap-4">
        <label for={@id} class="block text-sm">{@label}</label>
        {render_slot(@label_action)}
      </div>
      <div class="relative">
        <input
          type={@type}
          id={@id}
          name={@name}
          class={[input_classes(@errors), @errors != [] && "pe-11"]}
          aria-invalid={@errors != [] && "true"}
          aria-describedby={@errors != [] && "#{@id}-error"}
          {@rest}
        />
        <div
          :if={@errors != []}
          class="pointer-events-none absolute inset-y-0 end-0 flex items-center pe-3"
        >
          <.icon name="circle-alert" class="size-4 shrink-0 text-red-400" />
        </div>
      </div>
      <.error :for={msg <- @errors} id={"#{@id}-error"}>{msg}</.error>
    </div>
    """
  end

  defp input_classes(errors) do
    [
      "block w-full rounded-lg border bg-base-100 px-4 py-3 text-[15px] placeholder:text-muted/50 transition-colors focus:ring-1 focus:outline-hidden disabled:pointer-events-none disabled:opacity-50",
      if errors == [] do
        "border-base-300 focus:border-gold focus:ring-gold"
      else
        "border-red-400 focus:border-red-400 focus:ring-red-400"
      end
    ]
  end

  @doc """
  Renders one of the inline (lucide-style) icons used by the header.
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(assigns) do
    ~H"""
    <svg
      class={@class}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
    >
      <%= case @name do %>
        <% "home" -> %>
          <path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8" />
          <path d="M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
        <% "user" -> %>
          <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
          <circle cx="12" cy="7" r="4" />
        <% "wine" -> %>
          <path d="M8 22h8" />
          <path d="M7 10h10" />
          <path d="M12 15v7" />
          <path d="M12 15a5 5 0 0 0 5-5c0-2-.5-4-2-8H9c-1.5 4-2 6-2 8a5 5 0 0 0 5 5Z" />
        <% "heart" -> %>
          <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z" />
        <% "chevron-down" -> %>
          <path d="m6 9 6 6 6-6" />
        <% "calendar" -> %>
          <path d="M8 2v4" />
          <path d="M16 2v4" />
          <rect width="18" height="18" x="3" y="4" rx="2" />
          <path d="M3 10h18" />
        <% "map-pin" -> %>
          <path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0" />
          <circle cx="12" cy="10" r="3" />
        <% "lock" -> %>
          <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
          <path d="M7 11V7a5 5 0 0 1 10 0v4" />
        <% "sparkles" -> %>
          <path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z" />
          <path d="M20 3v4" />
          <path d="M22 5h-4" />
          <path d="M4 17v2" />
          <path d="M5 18H3" />
        <% "mail" -> %>
          <rect width="20" height="16" x="2" y="4" rx="2" />
          <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
        <% "eye" -> %>
          <path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0" />
          <circle cx="12" cy="12" r="3" />
        <% "eye-off" -> %>
          <path d="M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49" />
          <path d="M14.084 14.158a3 3 0 0 1-4.242-4.242" />
          <path d="M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143" />
          <path d="m2 2 20 20" />
        <% "menu" -> %>
          <line x1="3" x2="21" y1="6" y2="6" />
          <line x1="3" x2="21" y1="12" y2="12" />
          <line x1="3" x2="21" y1="18" y2="18" />
        <% "close" -> %>
          <path d="M18 6 6 18" />
          <path d="m6 6 12 12" />
        <% "circle-alert" -> %>
          <circle cx="12" cy="12" r="10" />
          <line x1="12" x2="12" y1="8" y2="12" />
          <line x1="12" x2="12.01" y1="16" y2="16" />
      <% end %>
    </svg>
    """
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(OrangerieWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(OrangerieWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  # Helper used by inputs to generate form errors
  attr :id, :string, default: nil
  slot :inner_block, required: true

  defp error(assigns) do
    ~H"""
    <p id={@id} class="mt-2 flex gap-2 items-center text-sm text-red-400">
      <.icon name="circle-alert" class="size-5" />
      {render_slot(@inner_block)}
    </p>
    """
  end
end
