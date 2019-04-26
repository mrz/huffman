defmodule HuffmanTest do
  use ExUnit.Case
  doctest Huffman

  defp replicate(x, n), do: for(_ <- 1..n, do: x)

  setup do
    as = replicate('a', 15)
    bs = replicate('b', 7)
    cs = replicate('c', 6)
    ds = replicate('d', 6)
    es = replicate('e', 5)

    input = Enum.shuffle(as ++ bs ++ cs ++ ds ++ es) |> to_string

    {:ok, input: input}
  end

  test "weights", state do
    expected = %{"e" => 5, "d" => 6, "c" => 6, "b" => 7, "a" => 15}
    actual = Huffman.calc_weights(state[:input])

    assert expected == actual
  end

  test "sorts" do
    expected = [{"e", 5}, {"d", 6}, {"c", 6}, {"b", 7}, {"a", 15}]
    actual = Huffman.sort(%{"e" => 5, "d" => 6, "c" => 6, "b" => 7, "a" => 15})

    assert expected == actual
  end

end
