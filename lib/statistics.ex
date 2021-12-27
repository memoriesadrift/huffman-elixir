defmodule Huffman.Statistics do
  alias Huffman.Encoder, as: Encoder
  # TODO: Finish moduledoc
  @moduledoc """
  Contains functions to statistically analyse Huffman Encoded texts.
  """

  # TODO: Finish doc
  @doc """
  Calculates the average code length of a given text string by encoding it
  and comparing the lengths of the two strings.
  ### Examples
  """
  @spec average_code_length(String.t, map) :: float
  def average_code_length(text, encoding) do
    text
    |> String.length()
    |> Kernel.then(fn text_length ->
      code_length(text, encoding)
      |> Kernel.then(&(&1/text_length))
    end)
  end

  # TODO: Finish doc
  @doc """
  Calculates the entropy of a text given its frequency distribution
  ### Examples
  """
  @spec calculate_entropy(map) :: number
  def calculate_entropy(frequencies) do
    text_length = frequencies |> Enum.map(fn {_k, v} -> v end) |> Enum.sum

    frequencies
    |> Enum.map(fn {_k, v} ->
      p = v / text_length
      p * :math.log2(p)
    end)
    |> Enum.sum
    |> Kernel.then(&(&1 * -1))
  end

  # TODO: Finish doc
  @doc """
  Calculates the savings a given encoding achieves on a text compared to `compare_to`.
  `compare_to` can be either `:ascii`, `:utf8` or another Huffman encoding generated with `Huffman.Encoder.generate_encoding/1`.
  ###Examples
  """
  @spec code_savings(binary, map, any) :: {:error, String.t} | {:ok, float}
  def code_savings(text, encoding, compare_to) do
    text_length = String.length(text)

    Encoder.encode_text(text, encoding)
    |> String.length()
    |> Kernel.then(fn encoded_length ->
      cond do
        compare_to == :ascii ->
          {:ok, to_percent(encoded_length / (text_length * 7))}
        compare_to == :utf8 ->
          {:ok, to_percent(encoded_length / (text_length * 8))}
        is_map(compare_to) ->
          second_encoded_length = Encoder.encode_text(text, compare_to) |> String.length()
          {:ok, to_percent(encoded_length / second_encoded_length)}
        true ->
          {:error, "Invalid option for parameter: 'compare_to!'. Must be one of :ascii, :utf8, or map()"}
      end
    end)
  end

  defp code_length(text, encoding) do
    Encoder.encode_text(text, encoding)
    |> String.length()
  end

  defp to_percent(fraction), do: fraction * 100

end
