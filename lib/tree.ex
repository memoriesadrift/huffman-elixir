defmodule Huffman.Tree do
  # TODO: Finish moduledoc
  @moduledoc """
  Mostly generic Huffman tree graph implementation.
  """

  @type tree :: %{value: any, children: list(tree)}

  @spec new(any, list(any)) :: tree
  @doc """
  Constructs a new tree with the given value and children.
  Creates an empty tree by default.

  ## Examples
  ```
  iex> Huffman.Tree.new()
  %{value: nil, children: []}
  ```
  """
  # TODO: Verify that children are of arity 0, 1 or 2
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
  def join(left, right, join_fn) do
    %{value: join_fn.(left.value, right.value), children: [left, right]}
  end

  @spec search(tree, any) :: {:found | :not_found, tree}
  @doc """
  Searches a tree for an element.
  Does not assume any ordering of the tree, such as smaller values
  stored in left nodes (binary search tree).

  ## Examples
  ```
  ```
  """
  def search(tree, what) when tree.value === what, do: {:found, tree}
  def search(tree, what) when tree.value !== what do
    tree.children
    |> Enum.map(&(search(&1, what)))
    |> Enum.filter(fn {status, _} -> status === :found end)
    |> Enum.at(0, {:not_found, new()})
  end

  # TODO: Implement for completeness.
  #def insert()
  #def delete()
  #def inorder()
  #def preorder()
  #def postorder()
end
