defmodule OrangerieWeb.ClubPageHTML do
  @moduledoc """
  This module contains the "Das Haus" pages rendered by ClubPageController,
  plus the components they share (arch image, page card, photo gallery).

  See the `club_page_html` directory for all templates available.
  """
  use OrangerieWeb, :html

  embed_templates "club_page_html/*"

  @doc """
  The signature arch-window image. Pages without photographs (Garten, Spa)
  get a decorative candlelight gradient instead.
  """
  attr :image, :string, default: nil
  attr :alt, :string, default: nil
  attr :class, :string, default: "aspect-[4/5]"

  def arch_image(assigns) do
    ~H"""
    <div
      data-theme="dark"
      class={[
        "relative overflow-hidden rounded-t-full rounded-b-2xl border border-gold/30 bg-base-100",
        @class
      ]}
    >
      <img
        :if={@image}
        src={@image}
        alt={@alt}
        loading="lazy"
        class="absolute inset-0 size-full object-cover"
      />
      <div
        :if={is_nil(@image)}
        class="absolute inset-0 opacity-80 bg-[radial-gradient(70%_45%_at_50%_102%,color-mix(in_oklab,var(--color-primary)_50%,transparent),transparent_72%),radial-gradient(100%_45%_at_50%_-5%,color-mix(in_oklab,var(--color-leaf)_25%,transparent),transparent_70%)]"
        aria-hidden="true"
      >
      </div>
      <div
        class="pointer-events-none absolute inset-2 rounded-t-full rounded-b-xl border border-base-content/10"
        aria-hidden="true"
      >
      </div>
    </div>
    """
  end

  @doc """
  One house page as a card for the overview grid and the "Mehr vom Haus"
  navigation at the bottom of each page.
  """
  attr :page, :map, required: true

  def page_card(assigns) do
    ~H"""
    <article class="group">
      <a href={~p"/haus/#{@page.slug}"} class="block focus:outline-hidden">
        <div class="transition-colors duration-500 group-hover:[&>div]:border-gold/70">
          <.arch_image image={@page.image} alt={@page.image_alt} class="aspect-[3/4]" />
        </div>
        <h3 class="mt-4 text-center font-display text-2xl transition-colors group-hover:text-primary group-focus-visible:text-primary">
          {@page.title}
        </h3>
        <p class="mt-2 px-2 text-center text-sm leading-relaxed text-muted">
          {@page.teaser}
        </p>
      </a>
    </article>
    """
  end

  @doc """
  A photo strip: two columns on small screens, one per photo above.
  """
  attr :gallery, :list, required: true

  def photo_gallery(assigns) do
    ~H"""
    <div class={[
      "grid gap-4",
      length(@gallery) > 2 && "grid-cols-2 lg:grid-cols-4",
      length(@gallery) <= 2 && "grid-cols-2"
    ]}>
      <figure
        :for={photo <- @gallery}
        class="overflow-hidden rounded-2xl border border-base-300"
      >
        <img
          src={photo.image}
          alt={photo.alt}
          loading="lazy"
          class="aspect-square size-full object-cover transition-transform duration-700 hover:scale-105"
        />
      </figure>
    </div>
    """
  end
end
