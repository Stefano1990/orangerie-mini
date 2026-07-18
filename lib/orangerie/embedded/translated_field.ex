defmodule Orangerie.Embedded.TranslatedField do
  use Ash.Resource,
    data_layer: :embedded,
    extensions: [
      AshAdmin.Resource
    ]

  admin do
    form do
      field :de, type: :long_text
      field :fr, type: :long_text
    end
  end

  attributes do
    attribute :de, :string do
      public? true
      allow_nil? false
    end

    attribute :fr, :string do
      public? true
      allow_nil? false
    end
  end

  def translate(%__MODULE__{} = field) do
    %{language: active_language} = Localize.get_locale()
    Map.get(field, active_language)
  end
end
