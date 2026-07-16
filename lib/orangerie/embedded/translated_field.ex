defmodule Orangerie.Embedded.TranslatedField do
  use Ash.Resource, data_layer: :embedded

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
end
