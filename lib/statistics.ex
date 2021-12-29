defmodule Huffman.Statistics do
  alias Huffman.Encoder, as: Encoder
  alias Huffman.Encodings, as: Encodings
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
          {:ok, 100 - to_percent(encoded_length / (text_length * 7))}
        compare_to == :utf8 ->
          {:ok, 100 - to_percent(encoded_length / (text_length * 8))}
        is_map(compare_to) ->
          second_encoded_length = Encoder.encode_text(text, compare_to) |> String.length()
          {:ok, 100 - to_percent(encoded_length / second_encoded_length)}
        true ->
          {:error, "Invalid option for parameter: 'compare_to'! Must be one of :ascii, :utf8, or map()"}
      end
    end)
  end

  defp code_length(text, encoding) do
    Encoder.encode_text(text, encoding)
    |> String.length()
  end

  # TODO: Write doc
  @spec generate_statistical_data({binary, map}, boolean) :: %{
          ascii_savings: float,
          average_code_length: float,
          average_code_length_en_freq: float,
          encoding: map,
          entropy: number,
          generic_savings: float,
          text_length: non_neg_integer,
          utf8_savings: float,
          runtimes: list(map)
        }
  def generate_statistical_data({text, frequencies}, benchmark \\ false) do
    # TODO: Include flag for comparing to en_freq as it may not be wanted at all times
    encoding = Encoder.generate_encoding(frequencies)

    %{
      :text_length => String.length(text),
      :encoding => encoding,
      :average_code_length => average_code_length(text, encoding),
      :average_code_length_en_freq => average_code_length(text, Encodings.en_freq),
      :entropy => calculate_entropy(frequencies),
      :utf8_savings => elem(code_savings(text, encoding, :utf8), 1),
      :ascii_savings => elem(code_savings(text, encoding, :ascii), 1) ,
      :generic_savings => elem(code_savings(text, encoding, Encodings.en_freq), 1),
      :runtimes => if(benchmark, do: Huffman.NTM.measure_runtimes({text, frequencies}), else: [])
    }
  end

  # TODO: Write doc
  @spec generate_multisample_statistical_data(list({String.t, map}), boolean) :: %{
          ascii_savings: float,
          average_code_length: float,
          average_code_length_en_freq: float,
          entropy: float,
          generic_savings: float,
          text_length: float,
          utf8_savings: float,
          runtimes: list(map)
        }
  def generate_multisample_statistical_data(texts_with_frequencies, benchmark \\ false) do
    texts_with_frequencies
    |> Enum.map(fn {text, frequency} -> generate_statistical_data({text, frequency}, benchmark) end)
    |> Kernel.then(fn list ->
      len = length(list)

      list
      # Sum the relevant entries
      |> Enum.reduce(%{
        :text_length => 0,
        :average_code_length => 0,
        :average_code_length_en_freq => 0,
        :entropy => 0,
        :utf8_savings => 0,
        :ascii_savings => 0,
        :generic_savings => 0,
        :runtimes => []
      }, fn e, acc ->
        %{
        :text_length => e.text_length + acc.text_length,
        :average_code_length => e.average_code_length + acc.average_code_length,
        :average_code_length_en_freq => e.average_code_length_en_freq + acc.average_code_length_en_freq,
        :entropy => e.entropy + acc.entropy,
        :utf8_savings => e.utf8_savings + acc.utf8_savings,
        :ascii_savings => e.ascii_savings + acc.ascii_savings,
        :generic_savings => e.generic_savings + acc.generic_savings,
        :runtimes => e.runtimes ++ acc.runtimes
        }
      end)
      # Take the averages of the totals
      |> Kernel.then(fn totals ->
        new_code_runtimes = totals.runtimes
        |> Enum.filter(fn elem -> elem.name == "new_code_runtime" end)
        |> Enum.map(&(&1.runtime))
        |> Enum.sum()
        |> Kernel./(len)

        en_freq_runtimes = totals.runtimes
        |> Enum.filter(fn elem -> elem.name == "en_freq_runtime" end)
        |> Enum.map(&(&1.runtime))
        |> Enum.sum()
        |> Kernel./(len)

        %{
        :text_length => totals.text_length / len,
        :average_code_length => totals.average_code_length / len,
        :average_code_length_en_freq => totals.average_code_length_en_freq / len,
        :entropy => totals.entropy / len,
        :utf8_savings => totals.utf8_savings / len,
        :ascii_savings => totals.ascii_savings / len,
        :generic_savings => totals.generic_savings / len,
        :runtimes => [%{:name => "new_code_runtime", :runtime => new_code_runtimes}, %{:name => "en_freq_runtime", :runtime => en_freq_runtimes}]
        }
      end)
    end)
  end

  defp to_percent(fraction), do: fraction * 100
end
