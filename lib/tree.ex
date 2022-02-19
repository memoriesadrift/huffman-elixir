defmodule Huffman.Tree do
  @moduledoc """
  A generic tree graph implementation containing only what's important for Huffman encoding.
  """

  @type tree :: %{value: any, children: list(tree)}

  @doc """
  Constructs a new tree with the given value and children.
  Creates an empty tree by default.

  ## Examples
  ```
  iex> Huffman.Tree.new()
  %{value: nil, children: []}
  ```
  """
  @spec new(any, list(any)) :: tree
  def new(value \\ nil, children \\ []), do: %{value: value, children: children}

  @doc """
  Joins two trees into a new tree.

  ## Examples
  ```
  iex> Huffman.Tree.join(%{value: 1, children: []}, %{value: 2, children: []}, fn v1, v2 -> v1 + v2 end)
  %{value: 3, children: [%{value: 1, children: []}, %{value: 2, children: []}]}
  ```
  """
  @spec join(tree, tree, fun) :: tree
  def join(left, right, join_fn), do: new(join_fn.(left.value, right.value), [left, right])
end
