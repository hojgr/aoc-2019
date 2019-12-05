defmodule Aoc.Day5 do
    def string_to_int(str), do: Integer.parse(str) |> elem(0)

    defp solve_opcode(program, ptr, modes, operation) do
        output_ptr = Enum.at(program, ptr + 3)

        input1 = get_opcode_parameter(program, ptr, 1, modes)
        input2 = get_opcode_parameter(program, ptr, 2, modes)

        List.update_at(program, output_ptr, fn _ -> operation.(input1, input2) end)
    end

    defp get_opcode_parameter(program, ptr, ptr_offset, modes) do
        if Enum.at(modes, ptr_offset - 1, 0) == 0 do # position mode
            input_ptr = Enum.at(program, ptr + ptr_offset)
            Enum.at(program, input_ptr)
        else # immediate
            Enum.at(program, ptr + ptr_offset)
        end
    end

    defp solve_input(program, ptr, _) do
        input = IO.gets("") |> Aoc.Day5.string_to_int

        output_ptr = Enum.at(program, ptr + 1)

        List.update_at(program, output_ptr, fn _ -> input end)
    end

    defp solve_output(program, ptr, _) do
        output_ptr = Enum.at(program, ptr + 1)

        IO.puts(Enum.at(program, output_ptr))

        program
    end

    defp jump_if_true(program, ptr, modes) do
        input1 = get_opcode_parameter(program, ptr, 1, modes)

        if input1 != 0 do
            new_ptr = get_opcode_parameter(program, ptr, 2, modes) # test without parametric
            part1(new_ptr, program)
        else
            part1(ptr + 3, program)
        end
    end

    defp jump_if_false(program, ptr, modes) do
        input1 = get_opcode_parameter(program, ptr, 1, modes)

        if input1 == 0 do
            new_ptr = get_opcode_parameter(program, ptr, 2, modes) # test without parametric
            part1(new_ptr, program)
        else
            part1(ptr + 3, program)
        end
    end

    defp less_than(program, ptr, modes) do
        input1 = get_opcode_parameter(program, ptr, 1, modes)
        input2 = get_opcode_parameter(program, ptr, 2, modes)
        output_ptr = Enum.at(program, ptr + 3)

        num = case input1 < input2 do
            true -> 1
            false -> 0
        end

        part1(ptr + 4, List.update_at(program, output_ptr, fn _ -> num end))
    end

    defp equals(program, ptr, modes) do
        input1 = get_opcode_parameter(program, ptr, 1, modes)
        input2 = get_opcode_parameter(program, ptr, 2, modes)
        output_ptr = Enum.at(program, ptr + 3)

        num = case input1 == input2 do
            true -> 1
            false -> 0
        end

        part1(ptr + 4, List.update_at(program, output_ptr, fn _ -> num end))
    end


    def part1(ptr, program) do
        {opcode, modes} = Enum.at(program, ptr) |> Aoc.Day5.parse_opcode()

        case opcode do
            1 -> part1(ptr + 4, solve_opcode(program, ptr, modes, &+/2))
            2 -> part1(ptr + 4, solve_opcode(program, ptr, modes, &*/2))
            3 -> part1(ptr + 2, solve_input(program, ptr, modes))
            4 -> part1(ptr + 2, solve_output(program, ptr, modes))
            5 -> jump_if_true(program, ptr, modes)
            6 -> jump_if_false(program, ptr, modes)
            7 -> less_than(program, ptr, modes)
            8 -> equals(program, ptr, modes)
            99 -> program
        end
    end

    def parse_opcode(opcode) do
        opcode_str = Integer.to_string(opcode)
        opcode_str = String.pad_leading(opcode_str, 2, "0")
        case Regex.scan(~r/([0-9]+)?([0-9]{2})/, opcode_str) do
            [[_, modes, opcode]] -> {opcode |> Aoc.Day5.string_to_int, modes |> String.codepoints |> Enum.map(&Aoc.Day5.string_to_int/1) |> Enum.reverse}
        end
    end
end

input = File.read!("input.txt")

program = input |> String.split(",") |> Enum.map(&Aoc.Day5.string_to_int/1)

#Aoc.Day2.part1(0, Aoc.Day2.set_noun_verb_replaces(program, 12, 2)) |> Enum.at(0) |> IO.puts()
#Aoc.Day2.part2(0, 0, program) |> IO.puts()

#IO.inspect Aoc.Day5.parse_opcode(1002)
Aoc.Day5.part1(0, program)
