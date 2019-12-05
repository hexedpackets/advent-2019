defmodule Advent.Day1 do
  def solve() do
    Advent.input()
    |> fuel_requirement()
  end

  def fuel_requirement(modules) when is_list(modules) do
    modules
    |> Stream.map(&fuel_requirement/1)
    |> Enum.reduce(0, &+/2)
  end

  @doc ~S"""
  ## Tests

      iex> fuel_requirement(12)
      2

      iex> fuel_requirement(14)
      2

      iex> fuel_requirement(1969)
      966

      iex> fuel_requirement(100756)
      50346
  """
  def fuel_requirement(mass) when is_binary(mass), do: mass |> String.to_integer() |> fuel_requirement()
  def fuel_requirement(mass) do
    case fuel_calc(mass) do
      0 -> 0
      req -> req + fuel_requirement(req)
    end
  end

  def fuel_calc(mass) when mass < 6, do: 0
  def fuel_calc(mass), do: Integer.floor_div(mass, 3) - 2
end
