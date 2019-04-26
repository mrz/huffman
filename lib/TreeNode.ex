defmodule TreeNode do
  defstruct left: nil, right: nil, char: nil, value: nil

  def join_nodes(
        a = %TreeNode{left: _, right: _, char: _, value: value_a},
        b = %TreeNode{left: _, right: _, char: _, value: value_b}
      ) do
    if value_a < value_b do
      %TreeNode{left: a, right: b, value: value_a + value_b}
    else
      %TreeNode{left: b, right: a, value: value_a + value_b}
    end
  end

  def create_node({char, value}) do
    %TreeNode{char: char, value: value}
  end

  def find(%TreeNode{left: nil, right: nil} = node, char, _weight, acc) do
    if node.char == char do
      acc
    else
      :error
    end
  end

  def find(%TreeNode{left: left, right: nil} = node, char, weight, acc) do
    if node.char == char do
      acc
    else
      find(left, char, weight, acc <> "0")
    end
  end

  def find(%TreeNode{left: nil, right: right} = node, char, weight, acc) do
    if node.value == char do
      acc
    else
      find(right, char, weight, acc <> "1")
    end
  end

  def find(%TreeNode{left: left, right: right} = node, char, weight, acc) do
    cond do
      node.value == char ->
        acc

      node.value < weight ->
        :error

      true ->
        case find(left, char, weight, acc <> "0") do
          :error ->
            case find(right, char, weight, acc <> "1") do
              :error -> :error
              acc -> acc
            end

          acc ->
            acc
        end
    end
  end
end
