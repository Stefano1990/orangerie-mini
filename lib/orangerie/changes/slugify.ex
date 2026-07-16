defmodule Orangerie.Changes.Slugify do
  use Ash.Resource.Change

  @impl true
  def change(changeset, opts, _ctx) do
    attribute = Keyword.fetch!(opts, :attribute)
    value = Ash.Changeset.get_argument_or_attribute(changeset, attribute)

    case value do
      %{de: value_de, fr: _} ->
        slug = Slug.slugify(value_de)
        Ash.Changeset.change_attribute(changeset, :slug, slug)
      _ -> changeset
    end
  end
end
