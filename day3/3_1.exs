defmodule Aoc.Day3 do
    def direction_to_movement("U"), do: {0, 1}
    def direction_to_movement("D"), do: {0, -1}
    def direction_to_movement("R"), do: {1, 0}
    def direction_to_movement("L"), do: {-1, 0}

    def string_to_int(str), do: Integer.parse(str) |> elem(0)

    def parse_move(move) do
        case Regex.scan(~r/([UDLR]{1})([0-9]+)/, move) do
            [[_, direction, velocity]] -> {Aoc.Day3.direction_to_movement(direction), Aoc.Day3.string_to_int(velocity)}
        end
    end

    def block_wire(map, wire_id, wires, x \\ 0, y \\ 0)

    def block_wire(map, _, [], _, _) do
        map
    end
    
    def block_wire(map, wire_id, [wire | rest], x, y) do
        movement = elem(wire, 0)
        distance = elem(wire, 1)
        
        {new_map, new_x, new_y} = Aoc.Day3.block_wire_line(map, wire_id, movement, distance, x, y)

        block_wire(new_map, wire_id, rest, new_x, new_y)
    end

    def add_wire_to_map_part(map, pos, wire_id) do
        wires_at_pos = Tuple.to_list(Map.get(map, pos, {}))
    
        if Enum.member?(wires_at_pos, wire_id) do
            map
        else
            Map.update(map, pos, {wire_id}, &(Tuple.append(&1, wire_id)))
        end
    end

    def block_wire_line(map, _, _, 0, x, y) do
        {map, x, y}
    end

    def block_wire_line(map, wire_id, movement, distance, x, y) do
        new_x = x + elem(movement, 0)
        new_y = y + elem(movement, 1)

        new_map = Aoc.Day3.add_wire_to_map_part(map, {new_x, new_y}, wire_id)
        block_wire_line(new_map, wire_id, movement, distance - 1, new_x, new_y)
    end

    def has_more_than_one_wire?({_, wires}) do
        tuple_size(wires) > 1
    end

    def get_position({pos, _}), do: pos

    def pos_to_distance({x, y}) do
        abs(x) + abs(y)
    end
end

input = File.read!("input.txt")
wires = String.split(input, "\n")

wire1 = String.split(Enum.at(wires, 0), ",") |> Enum.map(&Aoc.Day3.parse_move/1)
wire2 = String.split(Enum.at(wires, 1), ",") |> Enum.map(&Aoc.Day3.parse_move/1)

blocking_map = %{} |> Aoc.Day3.block_wire(1, wire1) |> Aoc.Day3.block_wire(2, wire2)

blocking_map 
    |> Enum.filter(&Aoc.Day3.has_more_than_one_wire?/1) 
    |> Enum.map(&Aoc.Day3.get_position/1)
    |> Enum.map(&Aoc.Day3.pos_to_distance/1)
    |> Enum.min()
    |> IO.puts()
