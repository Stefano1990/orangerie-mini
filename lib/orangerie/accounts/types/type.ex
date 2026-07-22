defmodule Orangerie.Accounts.Types.Type do
  use Ash.Type.Enum, values: [:m, :f, :mf, :mm, :ff]
end
