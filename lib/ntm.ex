defmodule Huffman.NTM do
  alias Huffman.Encodings, as: Encodings
  alias Huffman.Encoder, as: Encoder
  @moduledoc """
  Module to compute what is necessary for the NTM project.
  """
  def report_savings(input) do
    measure_runtimes(input)
    |> generate_report()
  end

  def generate_report(benchmarks) do
    report = benchmarks
    |> Enum.map(fn benchmark ->
      cond do
        benchmark.name == "new_code_runtime" ->
          "Runtime for new code: #{benchmark.runtime |> Float.round(2)}ms"
        benchmark.name == "en_freq_runtime" ->
          "Runtime for EN_freq*: #{benchmark.runtime |> Float.round(2)}ms"
        true ->
          "Runtime for #{benchmark.name}: #{benchmark.runtime |> Float.round(2)}ms"
      end
    end)
    |> Enum.join("\n")

    time_loss = benchmarks
    |> Enum.map(&(&1.runtime))
    |> Enum.chunk_every(2)
    |> Enum.map(fn [x, y] -> Float.round(x-y, 2) end)
    |> Enum.join()

    """
    ==== Time Savings ====
    #{report}
    Time lost by encoding: #{time_loss} ms
    ======================
    """
  end

  defp generate_and_encode(text, frequencies) do
    encoding = Encoder.generate_encoding(frequencies)
    Encoder.encode_text(text, encoding)
  end

  def measure_runtimes({text, frequencies}) do
    runtimes = Benchee.run(
      %{
        "new_code_runtime" => fn -> generate_and_encode(text, frequencies) end,
        "en_freq_runtime" => fn -> Encoder.encode_text(text, Encodings.en_freq) end,
      },
      formatters: [
        Benchee.Formatters.Console
      ]
    )

    runtimes.scenarios
    |> Enum.map(fn scenario ->
      %{
        :name => scenario.job_name,
        :runtime => scenario.run_time_data.statistics.average / 1000000
      }
    end)
    |> Enum.filter(fn benchmark -> is_number(benchmark.runtime) end)
  end
end
