defmodule Huffman do
  alias Huffman.IO, as: IO
  alias Huffman.Encoder, as: Encoder
  alias Huffman.Statistics, as: Statistics

  # TODO: Finish moduledoc
  @moduledoc """
  Documentation for `Huffman`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Huffman.hello()
      :world

  """
  def hello do
    # Example uses
    # Calculate entropy
    IO.get_text_frequencies("sample")
    |> Statistics.calculate_entropy()

    # Write encoding to file
    #IO.get_text_frequencies("sample")
    #|> Encoder.generate_encoding()
    #|> IO.write_encoding_to_file("sample", "encoding", "txt")

    # Generate an encoding from text, encode a file and write it to a new file.
    #text = IO.get_text_frequencies("sample")
    #text
    #|> Encoder.generate_encoding()
    #|> Kernel.then(fn encoding ->
    #  Encoder.encode_text(text, encoding)
    #end)
    #|> IO.write_encoded_text_to_file("sample")
  end
end
