defmodule Orangerie.Events.Event do
  use Ash.Resource,
    otp_app: :orangerie,
    domain: Orangerie.Events,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  postgres do
    table "events"
    repo Orangerie.Repo
  end

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept [:title, :description, :date, :start_time]
      argument :event_series, :uuid, allow_nil?: false
      change manage_relationship(:event_series, type: :append)
    end

    read :current_month do
      filter expr(date >= start_of_month(today()) and date <= end_of_month(today()))
      prepare build(sort: :date)
    end

    read :for_year_and_month do
      argument :year, :integer, allow_nil?: false
      argument :month, :integer, allow_nil?: false
      argument :order, :atom, constraints: [one_of: [:asc, :desc]], default: :asc
      filter expr(year == ^arg(:year) and month == ^arg(:month))
      prepare build(sort: [date: arg(:order)])
    end

    update :update do
      primary? true
      accept [:title, :description, :date, :start_time]
      argument :event_series, :string, allow_nil?: false
      change manage_relationship(:event_series, type: :append)
      require_atomic? false
    end
  end

  preparations do
    prepare build(load: :past?)
  end

  changes do
    change {Orangerie.Changes.Slugify, attribute: :title}, only_when_valid?: true
  end

  changes do
    change load(:past?)
  end

  attributes do
    uuid_primary_key :id

    attribute :slug, :string do
      allow_nil? false
    end

    attribute :date, :date do
      allow_nil? false
    end

    attribute :start_time, :time do
      allow_nil? false
    end

    attribute :title, Orangerie.Embedded.TranslatedField do
      allow_nil? false
    end

    attribute :description, Orangerie.Embedded.TranslatedField do
      allow_nil? false
    end

    timestamps()
  end

  relationships do
    belongs_to :event_series, Orangerie.Events.EventSeries, allow_nil?: false
  end

  calculations do
    calculate :past?, :boolean, expr(date < today())
    calculate :year, :integer, expr(fragment("date_part('year', ?)", date))
    calculate :month, :integer, expr(fragment("date_part('month', ?)", date))
  end
end
