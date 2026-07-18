defmodule Orangerie.Expressions.EndOfMonth do
  use Ash.CustomExpression, name: :end_of_month, arguments: [[:date]]

  @impl true
  def expression(AshPostgres.DataLayer, [date]) do
    {:ok,
     expr(
       fragment(
         "(date_trunc('month', ?::date::timestamp) + interval '1 month' - interval '1 day')::date",
         ^date
       )
     )}
  end

  def expression(_data_layer, _args), do: :unknown

  def end_of_month(%Date{} = date), do: Date.end_of_month(date)
end
