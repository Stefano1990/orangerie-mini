defmodule OrangerieWeb.Components.PrelineComponents do
  @moduledoc """
  Preline-based UI components.

  The `header/1` component renders a classic responsive navbar. It is composed
  of a handful of small building blocks (`nav_link/1`, `nav_dropdown/1`,
  `dropdown_item/1`, `collapse_button/1` and `icon/1`) so the markup stays
  readable and the repeated pieces live in one place.
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
            class="flex-none font-script text-3xl leading-none text-primary focus:outline-hidden focus:opacity-80"
            href="#"
            aria-label="Orangerie"
          >Orangerie</a>

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
              <.nav_link icon="home" active>Landing</.nav_link>
              <.nav_link icon="user">Account</.nav_link>
              <.nav_link icon="briefcase">Work</.nav_link>
              <.nav_link icon="book">Blog</.nav_link>

              <.nav_dropdown />

              <!-- Button Group -->
              <div class="relative flex flex-wrap items-center gap-x-1.5 md:ps-2.5 mt-1 md:mt-0 md:ms-1.5 before:block before:absolute before:top-1/2 before:-inset-s-px before:w-px before:h-4 before:bg-base-300 before:-translate-y-1/2">
                <a
                  class="p-2 px-4 w-full flex items-center justify-center rounded-full border border-primary/40 text-sm text-primary hover:bg-primary hover:text-primary-content focus:outline-hidden focus:bg-primary focus:text-primary-content transition-colors"
                  href="#"
                >
                  <.icon name="user" class="shrink-0 size-4 me-3 md:me-2" /> Log in
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
  The navbar dropdown, including its nested sub-menu.
  """
  def nav_dropdown(assigns) do
    ~H"""
    <!-- Dropdown -->
    <div class="hs-dropdown [--strategy:static] md:[--strategy:fixed] [--adaptive:none] md:[--adaptive:adaptive] [--is-collapse:true] md:[--is-collapse:false]">
      <button
        id="hs-header-classic-dropdown"
        type="button"
        class="hs-dropdown-toggle w-full p-2 flex items-center text-[15px] text-base-content/75 hover:text-primary focus:outline-hidden focus:text-primary transition-colors"
        aria-haspopup="menu"
        aria-expanded="false"
        aria-label="Dropdown"
      >
        <.icon name="list" class="shrink-0 size-4 me-3 md:me-2 block md:hidden" /> Dropdown
        <.icon
          name="chevron-down"
          class="hs-dropdown-open:-rotate-180 md:hs-dropdown-open:rotate-0 duration-300 shrink-0 size-4 ms-auto md:ms-1"
        />
      </button>

      <div
        class="hs-dropdown-menu transition-[opacity,margin] duration-[0.1ms] md:duration-150 hs-dropdown-open:opacity-100 opacity-0 relative w-full md:w-52 hidden z-10 top-full ps-7 md:ps-0 md:bg-base-100 md:border md:border-base-300 md:rounded-2xl md:shadow-lg before:absolute before:-top-4 before:inset-s-0 before:w-full before:h-5 md:after:hidden after:absolute after:top-1 after:inset-s-4.5 after:h-[calc(100%-4px)] after:border-s after:border-base-300"
        role="menu"
        aria-orientation="vertical"
        aria-labelledby="hs-header-classic-dropdown"
      >
        <div class="py-1 md:px-1 space-y-0.5">
          <.dropdown_item>About</.dropdown_item>

          <div class="hs-dropdown [--strategy:static] md:[--strategy:absolute] [--adaptive:none] md:[--trigger:hover] [--is-collapse:true] md:[--is-collapse:false] relative">
            <button
              id="hs-header-classic-dropdown-sub"
              type="button"
              class="hs-dropdown-toggle w-full py-1.5 px-2 flex items-center rounded-lg text-sm text-base-content/80 hover:text-primary hover:bg-base-200 focus:outline-hidden focus:text-primary transition-colors"
            >
              Sub Menu
              <.icon
                name="chevron-down"
                class="hs-dropdown-open:-rotate-180 md:hs-dropdown-open:-rotate-90 md:-rotate-90 ms-auto shrink-0 size-4"
              />
            </button>

            <div
              class="hs-dropdown-menu transition-[opacity,margin] duration-[0.1ms] md:duration-150 hs-dropdown-open:opacity-100 opacity-0 relative md:w-48 hidden z-10 md:mt-2 md:mx-2.5! md:top-0 md:inset-e-full ps-7 md:ps-0 md:bg-base-100 md:border md:border-base-300 md:rounded-2xl md:shadow-lg before:hidden md:before:block before:absolute before:-inset-e-5 before:top-0 before:h-full before:w-5 md:after:hidden after:absolute after:top-1 after:inset-s-4.5 after:h-[calc(100%-4px)] after:border-s after:border-base-300"
              role="menu"
              aria-orientation="vertical"
              aria-labelledby="hs-header-classic-dropdown-sub"
            >
              <div class="p-1 space-y-0.5 md:space-y-1">
                <.dropdown_item>About</.dropdown_item>
                <.dropdown_item>Downloads</.dropdown_item>
                <.dropdown_item>Team Account</.dropdown_item>
              </div>
            </div>
          </div>

          <.dropdown_item>Downloads</.dropdown_item>
          <.dropdown_item>Team Account</.dropdown_item>
        </div>
      </div>
    </div>
    <!-- End Dropdown -->
    """
  end

  @doc """
  A single link inside a dropdown menu.
  """
  attr :href, :string, default: "#"
  slot :inner_block, required: true

  def dropdown_item(assigns) do
    ~H"""
    <a
      class="py-1.5 px-2 flex items-center rounded-lg text-sm text-base-content/80 hover:text-primary hover:bg-base-200 focus:outline-hidden focus:text-primary transition-colors"
      href={@href}
    >
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
        <% "briefcase" -> %>
          <path d="M12 12h.01" />
          <path d="M16 6V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2" />
          <path d="M22 13a18.15 18.15 0 0 1-20 0" />
          <rect width="20" height="14" x="2" y="6" rx="2" />
        <% "book" -> %>
          <path d="M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-2 2Zm0 0a2 2 0 0 1-2-2v-9c0-1.1.9-2 2-2h2" />
          <path d="M18 14h-8" />
          <path d="M15 18h-5" />
          <path d="M10 6h8v4h-8V6Z" />
        <% "list" -> %>
          <path d="m3 10 2.5-2.5L3 5" />
          <path d="m3 19 2.5-2.5L3 14" />
          <path d="M10 6h11" />
          <path d="M10 12h11" />
          <path d="M10 18h11" />
        <% "chevron-down" -> %>
          <path d="m6 9 6 6 6-6" />
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
