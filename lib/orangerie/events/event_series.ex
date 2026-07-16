defmodule Orangerie.Events.EventSeries do
  use Ash.Resource,
    otp_app: :orangerie,
    domain: Orangerie.Events,
    data_layer: AshPostgres.DataLayer

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

  attributes do
    attribute :slug, :string do
      primary_key? true
      allow_nil? false
    end

    attribute :name, Orangerie.Embedded.TranslatedField do
      allow_nil? false
    end

    attribute :allowed_profile_types, {:array, Orangerie.Enums.ProfileType} do
      # constraints [
      #   one_of: [:m, :f, :mf, :mm, :ff]
      # ]
      allow_nil? false
    end
  end

  changes do
    change {Orangerie.Changes.Slugify, attribute: :name}
  end
end
