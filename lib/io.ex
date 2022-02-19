defmodule Huffman.IO do
  # TODO: Generic paths
  # TODO: Add moduledoc

  @spec get_text(any, any, any, fun) :: binary
  def get_text(filepath, filename, filetype \\ "txt", filter_fn \\ fn e -> e end) do
    get_from_file(filepath, filename, filetype)
    |> String.downcase()
    |> String.graphemes()
    |> Enum.filter(&filter_fn.(&1))
    |> Enum.join()
  end

  @spec get_text_frequencies(String.t(), String.t(), String.t(), fun) :: map
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
  def get_text_frequencies(filepath, filename, filetype \\ "txt", filter_fn \\ fn e -> e end) do
    get_from_file(filepath, filename, filetype)
    |> String.downcase()
    |> String.graphemes()
    |> Enum.filter(&filter_fn.(&1))
    |> Enum.frequencies()
  end

  @spec get_text_and_frequencies(String.t(), String.t(), String.t(), fun) :: {binary, map}
  def get_text_and_frequencies(filepath, filename, filetype \\ "txt", filter_fn \\ fn e -> e end) do
    raw =
      get_from_file(filepath, filename, filetype)
      |> String.downcase()
      |> String.graphemes()

    text =
      raw
      |> Enum.filter(&filter_fn.(&1))
      |> Enum.join()

    frequencies =
      raw
      |> Enum.filter(&filter_fn.(&1))
      |> Enum.frequencies()

    {text, frequencies}
  end

  @spec get_encoding_from_file(String.t(), String.t(), String.t()) :: map
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
  def get_encoding_from_file(filepath, filename, filetype \\ "txt") do
    get_from_file(filepath, filename, filetype)
    |> String.split("\n")
    |> Enum.flat_map(&(String.split(&1, " => ") |> Kernel.then(fn [k, v] -> %{k => v} end)))
    |> Map.new()
  end

  @spec get_frequencies_from_file(String.t(), String.t(), String.t()) :: map
  @doc """
  Reads a frequency distribution from file `filename` with extension `filetype` and saves
  it as a map that can be used by further `Huffman` modules.


  ### Examples
  ```
  $ cat sample.txt
  c => 1
  o => 1
  s => 1
  y => 1
  iex> Huffman.IO.get_encoding_from_file("sample")
  %{"c" => 1, "o" => 1, "s" => 1, "y" => 1}
  ```
  """
  def get_frequencies_from_file(filepath, filename, filetype \\ "txt") do
    get_from_file(filepath, filename, filetype)
    |> String.split("\n")
    |> Enum.flat_map(
      &(String.split(&1, " => ")
        |> Kernel.then(fn [k, v] -> %{k => String.to_integer(v)} end))
    )
    |> Map.new()
  end

  @spec write_encoded_text_to_file(
          binary,
          String.t(),
          String.t(),
          String.t()
        ) :: :ok
  def write_encoded_text_to_file(data, filename, suffix \\ "encoded", filetype \\ "txt"),
    do: write_to_file(data, filename, suffix, filetype)

  @spec write_report_to_file(
          binary,
          String.t(),
          String.t(),
          String.t()
        ) :: :ok
  def write_report_to_file(data, filename, suffix \\ "report", filetype \\ "txt"),
    do: write_to_file(data, filename, suffix, filetype)

  @spec write_encoding_to_file(map, String.t(), String.t(), String.t()) :: :ok
  def write_encoding_to_file(encoding, filename, suffix \\ "encoding", filetype \\ "txt") do
    encoding
    |> Enum.map(& &1)
    |> Enum.map(fn {k, v} -> "#{k} => #{v}" end)
    |> Enum.join("\n")
    |> write_to_file(filename, suffix, filetype)
  end

  defp write_to_file(data, filename, suffix, filetype) do
    File.write!(Path.relative("output/#{filename}_#{suffix}.#{filetype}"), data)
  end

  defp get_from_file(filepath, filename, filetype) do
    File.read!(Path.relative("#{filepath}/#{filename}.#{filetype}"))
  end

  # def parse_corpus_csv(filepath, filename) do
  # end
end
