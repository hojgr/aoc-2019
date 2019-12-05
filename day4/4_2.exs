defmodule Aoc.Day4 do
    def has_adjecent_same_digits(num) do
        chars = Integer.to_charlist(num)

        has_adjecent_same_digits_recursive(chars, nil, 0)
    end

    defp has_adjecent_same_digits_recursive([], _, same_digit_count) when same_digit_count == 2 do
        true
    end

    defp has_adjecent_same_digits_recursive(chars, last_char, same_digit_count) when same_digit_count > 2 do
        case chars do
            [^last_char | rest] -> has_adjecent_same_digits_recursive(rest, last_char, same_digit_count + 1)
            [new_last_char | rest] -> has_adjecent_same_digits_recursive(rest, new_last_char, 0)
            [] -> false
        end
    end

    defp has_adjecent_same_digits_recursive([char | rest], last_char, same_digit_count) when same_digit_count == 2 do
        if char == last_char do
            has_adjecent_same_digits_recursive(rest, last_char, same_digit_count + 1)
        else
            true
        end
    end

    defp has_adjecent_same_digits_recursive(chars, last_char, same_digit_count) when same_digit_count == 0 do
        case chars do
            [^last_char | rest] -> has_adjecent_same_digits_recursive(rest, last_char, 2)
            [char | rest] -> has_adjecent_same_digits_recursive(rest, char, 0)
            [] -> false
        end
    end

    def is_increasing(num) do
        chars = Integer.to_string(num) |> String.codepoints

        is_increasing_recursive(chars, 0)
    end


    defp is_increasing_recursive([], _) do
        true
    end

    defp is_increasing_recursive([char | rest], last_num) do
        char_int = String.to_integer(char)
        cond do
            char_int >= last_num -> is_increasing_recursive(rest, char_int)
            true -> false
        end
    end
end

109165..576723 |> Enum.filter(&Aoc.Day4.is_increasing/1) |> Enum.filter(&Aoc.Day4.has_adjecent_same_digits/1) |> Enum.count() |> IO.puts