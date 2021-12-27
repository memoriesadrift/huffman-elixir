defmodule Huffman.IO do
  # TODO: Generic paths
  # TODO: Add moduledoc

  @spec get_text_frequencies(String.t, String.t) :: map
  @doc """
  Finds the frequency distribution for the text in file `filename` with extension `filetype`.
  ### Examples
  ```
  $ cat sample.txt
  cosy
  iex> Huffman.IO.get_text_frequencies("sample")
  %{"c" => 1, "o" => 1, "s" => 1, "y" => 1}
  ```
  """
  def get_text_frequencies(filename, filetype \\ "txt") do
    get_from_file(filename, filetype)
    |> String.downcase()
    |> String.graphemes()
    |> Enum.filter(&(&1 =~ ~r/[a-zA-Z ,.()?:!';-]/))
    |> Enum.frequencies()
  end

  @spec get_encoding_from_file(String.t, String.t) :: map
  @doc """
  Reads a Huffman encoding from file `filename` with extension `filetype` and saves
  it as a map that can be used by further `Huffman` modules.


  ### Examples
  ```
  $ cat sample.txt
  c => 10
  o => 11
  s => 00
  y => 01
  iex> Huffman.IO.get_encoding_from_file("sample")
  %{"c" => "10", "o" => "11", "s" => "00", "y" => "01"}
  ```
  """
  def get_encoding_from_file(filename, filetype \\ "txt") do
    get_from_file(filename, filetype)
    |> String.split("\n")
    |> Enum.flat_map(&(String.split(&1, " => ") |> Kernel.then(fn [k, v] -> %{k => v} end)))
    |> Map.new()
  end

  @spec write_encoded_text_to_file(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            ),
          String.t,
          String.t,
          String.t
        ) :: :ok
  def write_encoded_text_to_file(data, filename, suffix, filetype), do: write_to_file(data, filename, suffix, filetype)

  @spec write_encoding_to_file(map, String.t, String.t, String.t) :: :ok
  def write_encoding_to_file(encoding, filename, suffix \\ "encoding", filetype \\ "txt") do
    encoding
    |> Enum.map(&(&1))
    |> Enum.map(fn {k, v} -> "#{k} => #{v}" end)
    |> Enum.join("\n")
    |> write_to_file(filename, suffix, filetype)
  end

  defp write_to_file(data, filename, suffix, filetype) do
    File.write!(Path.relative("output/#{filename}_#{suffix}.#{filetype}"), data)
  end

  defp get_from_file(filename, filetype \\ "txt") do
    File.read!(Path.relative("input/#{filename}.#{filetype}"))
  end
end
