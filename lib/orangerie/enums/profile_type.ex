defmodule Orangerie.Enums.ProfileType do
  use Ash.Type.Enum, values: [:m, :f, :mf, :mm, :ff]
end
