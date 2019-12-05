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
      654

      iex> fuel_requirement(100756)
      33583
  """
  def fuel_requirement(mass) when is_integer(mass) do
    Integer.floor_div(mass, 3) - 2
  end

  def fuel_requirement(mass) when is_binary(mass), do: mass |> String.to_integer() |> fuel_requirement()
end
