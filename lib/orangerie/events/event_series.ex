defmodule Orangerie.Events.EventSeries do
  use Ash.Resource,
    otp_app: :orangerie,
    domain: Orangerie.Events,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  admin do
    label_field :slug
    relationship_display_fields [:slug]
  end

  postgres do
    table "event_series"
    repo Orangerie.Repo
  end

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept [:name, :allowed_profile_types]
    end

    update :update do
      primary? true
      accept [:name, :allowed_profile_types]
      require_atomic? false
    end
  end

  changes do
    change {Orangerie.Changes.Slugify, attribute: :name}, only_when_valid?: true
  end

  attributes do
    uuid_primary_key :id
    attribute :slug, :string, allow_nil?: false
    attribute :name, Orangerie.Embedded.TranslatedField, allow_nil?: false
    attribute :allowed_profile_types, {:array, Orangerie.Enums.ProfileType}, allow_nil?: false
  end

  identities do
    identity :unique_slug, [:slug]
  end
end
