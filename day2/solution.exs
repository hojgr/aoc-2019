defmodule Aoc.Day2 do
    def string_to_int(str), do: Integer.parse(str) |> elem(0)

    def solve_opcode(program, ptr, operation) do
        input1_ptr = Enum.at(program, ptr + 1)
        input2_ptr = Enum.at(program, ptr + 2)
        output_ptr = Enum.at(program, ptr + 3)

        input1 = Enum.at(program, input1_ptr)
        input2 = Enum.at(program, input2_ptr)

        List.update_at(program, output_ptr, fn _ -> operation.(input1, input2) end)
    end

    def part1(ptr, program) do
        opcode = Enum.at(program, ptr)
        
        case opcode do
            1 -> part1(ptr + 4, solve_opcode(program, ptr, &+/2))
            2 -> part1(ptr + 4, solve_opcode(program, ptr, &*/2))
            99 -> program
        end
    end

    def set_noun_verb_replaces(program, noun, verb) do
        program |> List.update_at(1, fn _ -> noun end) |> List.update_at(2, fn _ -> verb end) 
    end

    def part2(noun, verb, program) do
        output = Aoc.Day2.part1(0, Aoc.Day2.set_noun_verb_replaces(program, noun, verb)) |> Enum.at(0)

        cond do
            output == 19690720 -> 
                100 * noun + verb
            noun < 100 -> 
                part2(noun + 1, verb, program)
            noun >= 100 -> 
                part2(0, verb + 1, program)
        end
    end
end

input = File.read!("input.txt")

program = input |> String.split(",") |> Enum.map(&Aoc.Day2.string_to_int/1)

#Aoc.Day2.part1(0, Aoc.Day2.set_noun_verb_replaces(program, 12, 2)) |> Enum.at(0) |> IO.puts()

Aoc.Day2.part2(0, 0, program) |> IO.puts()