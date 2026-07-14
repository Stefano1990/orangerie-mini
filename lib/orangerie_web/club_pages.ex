defmodule OrangerieWeb.ClubPages do
  @moduledoc """
  Static content for the "Das Haus" pages (restaurant, bar, salon, …).

  Each page is one map in `@pages`; the show template renders them all the
  same way, so adding a page means adding an entry here — no new templates.
  The list is ordered: it drives the header dropdown, the overview grid and
  the "next page" link at the bottom of each page. Images are dummy photos
  for now; pages with `image: nil` (Garten, Spa — we don't photograph them)
  render a decorative gradient arch instead.
  """

  @lounge "https://orangerie-prod.s3.eu-central-1.amazonaws.com/static_pages/welcome"

  @pages [
    %{
      slug: "restaurant",
      title: "Das Restaurant",
      tagline: "Die Liebe geht auch durch den Gaumen.",
      teaser: "Fine Dining auf einem Niveau, das in dieser Szene niemand erwartet.",
      image: "#{@lounge}/lounge3.jpg",
      image_alt: "Gedeckter Tisch im Séparée mit Kerzenlicht an oxblutroter Wand",
      intro:
        "In der Landschaft der Lifestyle-Clubs ist die Orangerie ein Unikum: " <>
          "eine Küche, die man auch dann besuchen würde, wenn dahinter kein " <>
          "Abend warten würde. Fine Dining ist hier kein Rahmenprogramm — " <>
          "es ist der erste Akt.",
      sections: [
        %{
          title: "Zwei Köchinnen, eine Überzeugung",
          body:
            "Verena ist gelernte Köchin — und eine leidenschaftliche dazu. " <>
              "Zusammen mit Mirella führt sie die Küche mit einem einfachen " <>
              "Anspruch: verführen und verwöhnen, Teller für Teller. " <>
              "«Vom Guten nur das Beste» ist dabei keine Floskel, sondern die " <>
              "Vorgabe, der Küche und Serviceteam jeden Abend aufs Neue " <>
              "entsprechen wollen — zu Preisen, die überraschend freundlich sind.",
          image: "#{@lounge}/lounge4.jpg",
          image_alt: "Der grosse Saal mit Kronleuchtern und gedeckten Tischen"
        },
        %{
          title: "Marktfrisch, saisonal, überraschend",
          body:
            "Die Karte wechselt mit der Saison: leichte, marktfrische Küche, " <>
              "erlesen zubereitet — raffiniert, kreativ, manchmal ungewohnt, " <>
              "aber ganz sicher schmack- und herzhaft. Wer sich einstimmen " <>
              "möchte, wirft vorab einen Blick auf die Speise- und Getränkekarte.",
          image: "#{@lounge}/lounge2.jpg",
          image_alt: "Die beleuchtete Bar mit Blick in den Speisesaal"
        },
        %{
          title: "Der erste Akt des Abends",
          body:
            "Zu den köstlichen Dingen im Leben zählt für uns ganz " <>
              "selbstverständlich das Essen und Trinken. Ein Abend in der " <>
              "Orangerie beginnt deshalb am Tisch — und niemand muss ihn " <>
              "dort beenden.",
          image: "#{@lounge}/lounge5.jpg",
          image_alt: "Der Salon mit Ledersofas, im Hintergrund der Speisesaal"
        }
      ],
      notes: %{
        title: "Gut zu wissen",
        items: [
          "Küche Freitag und Samstag bis 01:30 Uhr",
          "Sonntag bis 20:30 Uhr",
          "Tischreservation empfohlen — am einfachsten direkt beim Haus"
        ]
      },
      gallery: [
        %{image: "#{@lounge}/lounge3.jpg", alt: "Séparée mit gedeckten Tischen"},
        %{image: "#{@lounge}/lounge4.jpg", alt: "Der grosse Saal am Abend"},
        %{image: "#{@lounge}/lounge2.jpg", alt: "Die Bar vor dem Service"},
        %{image: "#{@lounge}/lounge5.jpg", alt: "Der Salon bei Kerzenlicht"}
      ]
    },
    %{
      slug: "bar",
      title: "Die Bar",
      tagline: "Hier beginnt jeder Abend.",
      teaser: "Die lange Bar im Herzen des Hauses — erster Treffpunkt jedes Abends.",
      image: "#{@lounge}/lounge2.jpg",
      image_alt: "Die beleuchtete Bar mit Barhockern unter der Galerie",
      intro:
        "Die lange Bar liegt im Herzen des Hauses, unter der Galerie mit dem " <>
          "schmiedeeisernen Geländer. Hier trifft man an, bevor man ankommt: " <>
          "ein erstes Glas, bekannte Gesichter — und neue.",
      sections: [
        %{
          title: "Klassiker, korrekt gebaut",
          body:
            "Die Karte reicht vom Champagner bis zum Negroni, dazu eine " <>
              "kleine, gepflegte Auswahl an alkoholfreien Begleitern. Nichts " <>
              "Exotisches um des Effekts willen — dafür jedes Glas so, wie " <>
              "es sein muss.",
          image: "#{@lounge}/lounge5.jpg",
          image_alt: "Blick von der Bar in den Salon"
        }
      ],
      notes: nil,
      gallery: [
        %{image: "#{@lounge}/lounge2.jpg", alt: "Die Bar am frühen Abend"},
        %{image: "#{@lounge}/lounge4.jpg", alt: "Die Galerie über der Bar"}
      ]
    },
    %{
      slug: "salon",
      title: "Der Salon",
      tagline: "Das Wohnzimmer des Hauses.",
      teaser: "Ledersofas, Teppiche, Kerzenlicht — hier vergehen die Stunden.",
      image: "#{@lounge}/lounge5.jpg",
      image_alt: "Der grosse Salon mit Ledersofas und Marmortischen",
      intro:
        "Ledersofas, Teppiche, Marmortische und Kerzenlicht: Der Salon ist " <>
          "das Wohnzimmer des Hauses — der Ort, an dem aus Bekanntschaften " <>
          "Gespräche werden und aus Gesprächen mehr.",
      sections: [
        %{
          title: "Bühne und Catwalk",
          body:
            "An den Eventabenden gehört die Bühne dem Programm: Shows, Musik " <>
              "und der Catwalk mitten durch den Salon. Danach wird das Licht " <>
              "wärmer und der Raum wieder leiser.",
          image: "#{@lounge}/lounge4.jpg",
          image_alt: "Der Saal mit Bühne und Catwalk"
        }
      ],
      notes: nil,
      gallery: [
        %{image: "#{@lounge}/lounge5.jpg", alt: "Sitzgruppen im Salon"},
        %{image: "#{@lounge}/lounge3.jpg", alt: "Séparée neben dem Salon"}
      ]
    },
    %{
      slug: "garten",
      title: "Der Garten",
      tagline: "Offenes Feuer, offener Himmel.",
      teaser: "Feuer in der Gartenhütte, darüber der Himmel über dem Thurgau.",
      image: nil,
      image_alt: nil,
      intro:
        "Hinter dem Haus liegt der Garten: offenes Feuer in der Gartenhütte, " <>
          "Gespräche unter freiem Himmel und die Ruhe des Thurgaus. Was hier " <>
          "beginnt, geht drinnen weiter — oder eben nicht.",
      sections: [],
      notes: %{
        title: "Warum keine Fotos?",
        items: [
          "Garten und Spa fotografieren wir nicht — Diskretion beginnt bei uns selbst.",
          "Wer den Garten sehen will, kommt am besten an einem lauen Abend vorbei."
        ]
      },
      gallery: []
    },
    %{
      slug: "spa",
      title: "Das Spa",
      tagline: "Für später.",
      teaser: "Sauna, Whirlpool und stille Ecken — der leiseste Teil des Hauses.",
      image: nil,
      image_alt: nil,
      intro:
        "Sauna, Whirlpool und stille Ecken für später: Das Spa ist der " <>
          "leiseste Teil des Hauses. Frottée liegt bereit, der Rest bleibt " <>
          "zwischen Ihnen und dem Abend.",
      sections: [],
      notes: %{
        title: "Warum keine Fotos?",
        items: [
          "Garten und Spa fotografieren wir nicht — Diskretion beginnt bei uns selbst."
        ]
      },
      gallery: []
    }
  ]

  def all, do: @pages

  def get(slug), do: Enum.find(@pages, &(&1.slug == slug))

  @doc "The page following `slug` in the tour, wrapping around at the end."
  def next(slug) do
    index = Enum.find_index(@pages, &(&1.slug == slug))
    Enum.at(@pages, Integer.mod(index + 1, length(@pages)))
  end
end
