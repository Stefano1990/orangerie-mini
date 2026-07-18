defmodule Orangerie.Changes.Slugify do
  use Ash.Resource.Change

  alias Orangerie.Events

  @impl true
  def change(changeset = %{data: %Events.Event{}}, opts, _ctx) do
    attribute = Keyword.fetch!(opts, :attribute)
    value = Ash.Changeset.get_argument_or_attribute(changeset, attribute)
    date = Ash.Changeset.get_argument_or_attribute(changeset, :date)

    case value do
      %{de: value_de, fr: _} ->
        slug = Slug.slugify(value_de)
        slug = "#{slug}-#{date.year}-#{date.month}-#{date.day}"
        Ash.Changeset.change_attribute(changeset, :slug, slug)

      _ ->
        changeset
    end
  end

  @impl true
  def change(changeset, opts, _ctx) do
    attribute = Keyword.fetch!(opts, :attribute)
    value = Ash.Changeset.get_argument_or_attribute(changeset, attribute)

    case value do
      %{de: value_de, fr: _} ->
        slug = Slug.slugify(value_de)
        Ash.Changeset.change_attribute(changeset, :slug, slug)

      _ ->
        changeset
    end
  end
end
