defmodule Advent.Wires do
  def solve() do
    Advent.input()
    |> String.split()
    |> fewest_steps()
  end

  @doc """
  ## Examples

      iex> fewest_steps(["R8,U5,L5,D3", "U7,R6,D4,L4"])
      30

      iex> fewest_steps(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"])
      610
  """
  def fewest_steps(inputs) do
    [wire1, wire2] = wire_mapping(inputs)

    find_crosses(wire1, wire2)
    |> Enum.filter(fn x -> x != {0, 0} end)
    |> Enum.map(fn crossing ->
      d1 = wire1 |> Enum.take_while(fn x -> x != crossing end) |> distance_travelled()
      d2 = wire2 |> Enum.take_while(fn x -> x != crossing end) |> distance_travelled()
      d1 + d2
    end)
    |> Enum.sort()
    |> List.first()
  end

  def distance_travelled(coordinates) do
    coordinates
    |> Enum.reduce({0, 0, 0}, fn {x, y}, {total, last_x, last_y} ->
      total = total + abs(x - last_x) + abs(y - last_y)
      {total, x, y}
    end)
    |> elem(0)
    |> Kernel.+(1)
  end

  @doc """
  ## Examples

      iex> closest_crossing_distance(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"])
      159

      iex> closest_crossing_distance(["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"])
      135
  """
  def closest_crossing_distance(inputs) do
    [wire1, wire2] = wire_mapping(inputs)

    find_crosses(wire1, wire2)
    |> Stream.map(&manhattan_distance/1)
    |> Stream.filter(fn x -> x != 0 end)
    |> Enum.sort()
    |> List.first()
  end

  @doc """
  ## Examples

      iex> [wire1, wire2] = wire_mapping(["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"])
      ...> find_crosses(wire1, wire2)
      ...> |> Enum.map(&manhattan_distance/1)
      [0, 192, 159, 166, 170]
  """
  def manhattan_distance({x, y}), do: abs(x) + abs(y)

  def find_crosses(wire1, wire2) do
    wire2 = MapSet.new(wire2)

    wire1
    |> MapSet.new()
    |> Enum.filter(fn pos -> MapSet.member?(wire2, pos) end)
  end

  def wire_mapping(inputs) do
    Enum.map(inputs, fn path ->
      path
      |> String.split(",")
      |> grid_positions()
    end)
  end

  def grid_positions(moves), do: grid_positions(moves, [{0,0}])
  def grid_positions([], positions), do: positions
  def grid_positions([<<direction, movement :: binary>> | tail], positions) do
    movement = String.to_integer(movement)
    {x, y} = List.last(positions)

    # NB: assumes movement is always > 0
    new_positions =
      case <<direction>> do
        "R" -> (x+1)..(x+movement) |> Enum.map(fn x -> {x, y} end)
        "L" -> (x-1)..(x-movement) |> Enum.map(fn x -> {x, y} end)
        "U" -> (y+1)..(y+movement) |> Enum.map(fn y -> {x, y} end)
        "D" -> (y-1)..(y-movement) |> Enum.map(fn y -> {x, y} end)
      end

    grid_positions(tail, positions ++ new_positions)
  end
end
