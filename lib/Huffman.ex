defmodule Huffman do
  import TreeNode

  @doc ~S"""
  Calculates the weights of the individual letters of the input string.

      iex> Huffman.calc_weights("aaabbc")
      %{"a" => 3, "b" => 2, "c" => 1}

  """
  def calc_weights(input, weights \\ %{})

  def calc_weights(<<letter::utf8, rest::binary>>, weights) do
    new_weights = Map.update(weights, <<letter::utf8>>, 1, &(&1 + 1))
    calc_weights(rest, new_weights)
  end

  def calc_weights(<<>>, weights), do: weights

  @doc ~S"""
  Sorts the weights as calculated by Huffman.calc_weights in reversed order,
  where the lowest weight is given highest priority.

  iex> Huffman.sort(%{"a" => 1, "b" => 2, "c" => 3})
  [{"a", 1}, {"b", 2}, {"c", 3}]

  """
  def sort(weights) do
    Enum.sort(weights, fn {_letter1, weight1}, {_letter2, weight2} -> weight1 < weight2 end)
  end

  def build_node_list(input) do
    Enum.map(input, &TreeNode.create_node/1)
  end

  def build_tree([first = %TreeNode{}, second = %TreeNode{} | rest]) do
    TreeNode.join_nodes(first, second)
    |> reprioritize(rest)
    |> build_tree()
  end

  def build_tree(single) do
    single
  end

  defp reprioritize(node, [first | rest]) do
    if node.value >= first.value do
      [first | reprioritize(node, rest)]
    else
      [node, first | rest]
    end
  end

  defp reprioritize(node, []) do
    [node]
  end

  def encode(input) do
    weights = calc_weights(input)

    tree =
      sort(weights)
      |> build_node_list
      |> build_tree

    {weights, do_encode(input, List.first(tree), weights)}
  end

  defp do_encode(input, tree, weights, res \\ "")

  defp do_encode(<<letter, rest::binary>>, tree, weights, res) do
    weight = Map.get(weights, <<letter::utf8>>)
    cur = TreeNode.find(tree, <<letter::utf8>>, weight, "")
    do_encode(rest, tree, weights, res <> cur)
  end

  defp do_encode(<<>>, tree, weights, res), do: res

  def decode(input, weights) do
    tree =
      sort(weights)
      |> build_node_list
      |> build_tree

    do_decode(input, List.first(tree), List.first(tree))
  end

  defp do_decode(input, tree, node)
  defp do_decode(input, tree, %TreeNode{left: nil, right: nil, char: char} = node) do
    char <> do_decode(input, tree, tree)
  end

  defp do_decode(<<"1", rest::binary>>, tree, node) do
    do_decode(rest, tree, node.right)
  end

  defp do_decode(<<"0", rest::binary>>, tree, node) do
    do_decode(rest, tree, node.left)
  end

  defp do_decode(<<>>, tree, node) do
    ""
  end

end

# as = replicate('a', 5)
# bs = replicate('b', 9)
# cs = replicate('c', 12)
# ds = replicate('d', 13)
# es = replicate('e', 16)
# fs = replicate('f', 45)
# %{97 => 5, 98 => 9, 99 => 12, 100 => 13, 101 => 16, 102 => 45}
