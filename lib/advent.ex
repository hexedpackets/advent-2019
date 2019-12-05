defmodule Advent do
  def input(path \\ "~/Downloads/input") do
    path
    |> Path.expand
    |> File.read!
    |> String.split
  end
end
