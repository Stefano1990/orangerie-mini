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

  Each photo opens the lightbox below. The thumbnail's button covers the tile
  rather than wrapping it, so the `<figure>` stays the hover group and the image
  keeps its own markup.
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
        class="group relative overflow-hidden rounded-2xl border border-base-300"
      >
        <img
          src={photo.image}
          alt={photo.alt}
          loading="lazy"
          class="aspect-square size-full object-cover transition-transform duration-700 group-hover:scale-105"
        />
        <button
          type="button"
          class="absolute inset-0 cursor-zoom-in focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-gold"
          data-hs-overlay="#photo-lightbox"
          data-lightbox-src={photo.image}
          data-lightbox-alt={photo.alt}
        >
          <span class="sr-only">Bild vergrössern: {photo.alt}</span>
        </button>
      </figure>
    </div>

    <.photo_lightbox />
    """
  end

  # The lightbox behind photo_gallery/1: one Preline overlay shared by every
  # thumbnail, showing nothing but the photograph on black. The clicked thumbnail
  # fills in src/alt (see app.js), so the markup here stays gallery-agnostic.
  defp photo_lightbox(assigns) do
    ~H"""
    <div
      id="photo-lightbox"
      class="hs-overlay pointer-events-none fixed start-0 top-0 z-80 hidden size-full"
      data-hs-overlay-options={
        ~s({"backdropClasses": "hs-overlay-backdrop fixed inset-0 bg-black transition duration-300"})
      }
      role="dialog"
      tabindex="-1"
      aria-label="Bild in voller Grösse"
    >
      <div class="hs-overlay-animation-target hs-overlay-open:scale-100 hs-overlay-open:opacity-100 flex size-full scale-95 items-center justify-center p-2 opacity-0 transition-all duration-300 sm:p-6">
        <img alt="" class="pointer-events-auto max-h-full max-w-full object-contain" />
      </div>

      <button
        type="button"
        class="pointer-events-auto absolute end-3 top-3 inline-flex size-10 items-center justify-center rounded-full text-white/70 hover:bg-white/10 hover:text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white"
        data-hs-overlay="#photo-lightbox"
      >
        <.icon name="hero-x-mark" class="size-6" />
        <span class="sr-only">Schliessen</span>
      </button>
    </div>
    """
  end
end
