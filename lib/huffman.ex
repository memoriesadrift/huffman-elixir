defmodule Huffman do
  alias Huffman.Encoder, as: Encoder
  alias Huffman.Statistics, as: Statistics
  alias Huffman.Encodings, as: Encodings
  alias Huffman.Reporting, as: Reporting

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
  # TODO: put this somewhere reasonable
  defp ntm_filter(e) do
    e =~ ~r/[a-zA-Z ,.()?:!';-]/
  end

  def hello do
    [
    ]
    |> Reporting.generate_multifile_report("input", "txt", &ntm_filter/1, true)
    |> Huffman.IO.write_report_to_file("multifile_benchmark")

    #Reporting.generate_report("input", "DAVID COPPERFIELD by Charles Dickens", "txt", &ntm_filter/1, true)

    # Example uses
    #|> generate_multifile_statistical_data("input", "txt")
    #Huffman.IO.get_text_frequencies("sample")
    #|> Statistics.calculate_entropy()

    # Generate code from frequencies saved in file
    #Huffman.IO.get_frequencies_from_file("input", "en_frequencies", "txt")
    #|> Encoder.generate_encoding()
    #|> Huffman.IO.write_encoding_to_file("en_freq")

    # Write encoding to file
    #Huffman.IO.get_text_frequencies("sample")
    #|> Encoder.generate_encoding()
    #|> Huffman.IO.write_encoding_to_file("sample", "encoding", "txt")

    # Generate an encoding from text, encode a file and write it to a new file.
    #text = Huffman.IO.get_text("Mark_Twain-A_TRAMP_ABROAD")
    #Enum.frequencies(String.split(text, ""))
    #|> Encoder.generate_encoding()
    #|> Kernel.then(fn encoding ->
      #Encoder.encode_text(text, encoding)
    #end)
    #|> Huffman.IO.write_encoded_text_to_file("twain-tramp")
  end
end
