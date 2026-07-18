defmodule Orangerie.Expressions.StartOfMonth do
  use Ash.CustomExpression, name: :start_of_month, arguments: [[:date]]

  @impl true
  def expression(AshPostgres.DataLayer, [date]) do
    {:ok, expr(fragment("date_trunc('month', ?::date::timestamp)::date", ^date))}
  end

  def expression(_data_layer, _args), do: :unknown

  def start_of_month(%Date{} = date), do: Date.beginning_of_month(date)
end
