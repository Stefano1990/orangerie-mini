defmodule Orangerie.Changes.Slugify do
  use Ash.Resource.Change

  alias Orangerie.Events

  @impl true
  def change(changeset, opts, _ctx) do
    attribute = Keyword.fetch!(opts, :attribute)
    value = Ash.Changeset.get_argument_or_attribute(changeset, attribute)

    if slug = slugify(changeset, value) do
      Ash.Changeset.change_attribute(changeset, :slug, slug)
    else
      changeset
    end
  end

  defp slugify(changeset = %{data: %Events.Event{}}, title) do
    date = Ash.Changeset.get_argument_or_attribute(changeset, :date)
    Slug.slugify("#{title.de}-#{date.year}-#{date.month}-#{date.day}")
  end

  defp slugify(_changeset, value) when is_map(value), do: Slug.slugify(value.de)
  defp slugify(_changeset, value) when is_binary(value), do: Slug.slugify(value)
  defp slugify(_changeset, _), do: nil
end
