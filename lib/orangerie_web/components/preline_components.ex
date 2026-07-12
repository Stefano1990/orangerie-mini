defmodule OrangerieWeb.Components.PrelineComponents do
  @moduledoc """
  Preline-based UI components.

  The `header/1` component renders a classic responsive navbar. It is composed
  of a handful of small building blocks (`nav_link/1`, `collapse_button/1` and
  `icon/1`) so the markup stays readable and the repeated pieces live in one
  place.
  """
  use Phoenix.Component

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
          class="hs-collapse hidden overflow-hidden transition-all duration-300 basis-full grow md:block"
          aria-labelledby="hs-header-classic-collapse"
          role="region"
        >
          <div class="overflow-hidden overflow-y-auto max-h-[75vh] [&::-webkit-scrollbar]:w-2 [&::-webkit-scrollbar-thumb]:rounded-full [&::-webkit-scrollbar-track]:bg-base-200 [&::-webkit-scrollbar-thumb]:bg-base-300">
            <div class="py-2 md:py-0 flex flex-col md:flex-row md:items-center md:justify-end gap-0.5 md:gap-1">
              <.nav_link href="#haus" icon="home" active>Das Haus</.nav_link>
              <.nav_link href="#abend" icon="wine">Der Abend</.nav_link>
              <.nav_link href="#etikette" icon="heart">Etikette</.nav_link>
              <.nav_link href="#kontakt" icon="map-pin">Kontakt</.nav_link>

              <!-- Button Group -->
              <div class="relative flex flex-wrap items-center gap-x-1.5 md:ps-2.5 mt-1 md:mt-0 md:ms-1.5 before:block before:absolute before:top-1/2 before:-inset-s-px before:w-px before:h-4 before:bg-base-300 before:-translate-y-1/2">
                <a
                  class="p-2 px-4 w-full flex items-center justify-center rounded-full border border-primary/40 text-sm text-primary hover:bg-primary hover:text-primary-content focus:outline-hidden focus:bg-primary focus:text-primary-content transition-colors"
                  href="#"
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
        <% "map-pin" -> %>
          <path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0" />
          <circle cx="12" cy="10" r="3" />
        <% "menu" -> %>
          <line x1="3" x2="21" y1="6" y2="6" />
          <line x1="3" x2="21" y1="12" y2="12" />
          <line x1="3" x2="21" y1="18" y2="18" />
        <% "close" -> %>
          <path d="M18 6 6 18" />
          <path d="m6 6 12 12" />
      <% end %>
    </svg>
    """
  end
end
