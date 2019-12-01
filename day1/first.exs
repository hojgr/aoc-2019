defmodule Aoc.Day1 do
  def compute_fuel(mass), do: floor(mass / 3) - 2

  def compute_fuel_recursive(mass) do
    fuel_mass = floor(mass / 3) - 2

    if fuel_mass > 0 do
      fuel_mass + Aoc.Day1.compute_fuel_recursive(fuel_mass)
    else
      0
    end
  end

  def string_to_int(str), do: Integer.parse(str) |> elem(0)

  def part1(input) do
    input |> String.split("\n")
          |> Enum.map(&Aoc.Day1.string_to_int/1)
          |> Enum.map(&Aoc.Day1.compute_fuel/1)
          |> Enum.sum()
  end

  def part2(input) do
    input |> String.split("\n")
          |> Enum.map(&Aoc.Day1.string_to_int/1)
          |> Enum.map(&Aoc.Day1.compute_fuel_recursive/1)
          |> Enum.sum()
  end
end

input = File.read!("input.txt")

IO.puts(Aoc.Day1.part2(input))


