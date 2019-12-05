defmodule Advent.Intcode do
  def solve() do
    Advent.input()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> process()
    |> List.first()
  end

  @doc ~S"""
  # Examples

      iex> process([1,0,0,0,99])
      [2,0,0,0,99]

      iex> process([2,3,0,3,99])
      [2,3,0,6,99]

      iex> process([2,4,4,5,99,0])
      [2,4,4,5,99,9801]

      iex> process([1,1,1,4,99,5,6,0,99])
      [30,1,1,4,2,5,6,0,99]
  """
  def process(memory), do: process(memory, 0)
  def process(memory, pointer) when is_integer(pointer) do
    case Enum.slice(memory, pointer, 4) do
      [] -> memory
      instruction -> instruction |> process(memory) |> process(pointer + 4)
    end
  end

  def process([1, addr1, addr2, addr3], memory) do
    value = Enum.at(memory, addr1) + Enum.at(memory, addr2)
    List.replace_at(memory, addr3, value)
  end

  def process([2, addr1, addr2, addr3], memory) do
    value = Enum.at(memory, addr1) * Enum.at(memory, addr2)
    List.replace_at(memory, addr3, value)
  end

  def process(_bad_operation, memory), do: memory
end
