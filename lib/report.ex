defmodule Huffman.Reporting do
  alias Huffman.Statistics, as: Statistics
  # TODO: Write moduledoc


  @spec generate_report(String.t, String.t, String.t, fun, boolean) :: <<_::64, _::_*8>>
  def generate_report(filepath, filename, filetype, filter_fn, ntm \\ false) do
    input = Huffman.IO.get_text_and_frequencies(filepath, filename, filetype, filter_fn)
    data = input
    |> Statistics.generate_statistical_data()

    runtimes = if(ntm, do: Huffman.NTM.report_savings(input), else: "")

    output = """
            Report for #{filepath}/#{filename}.#{filetype}

            Text length: #{data.text_length} (considered characters)

            Entropy: #{data.entropy}
            Average code length: #{data.average_code_length}
            En-freq* avg. code length: #{data.average_code_length_en_freq}

            ====== Code Savings ======
            Compared to UTF-8: #{data.utf8_savings |> Float.round(2)}%
            Compared to ASCII: #{data.ascii_savings |> Float.round(2)}%
            Compared to EN-freq*: #{data.generic_savings |> Float.round(2)}%
            ==========================

            #{runtimes}

            * EN-freq is a Huffman encoding based on the frequency distribution of
            characters in English language texts, created for this project.
            """
    output
  end

  @spec generate_multifile_report([String.t], String.t, String.t, fun, boolean) :: <<_::64, _::_*8>>
  def generate_multifile_report(filenames, filepath \\ "input", filetype \\ "txt", filter_fn \\ (fn e -> e end), benchmark \\ false) do
    data = filenames
      |> Enum.map(fn filename ->
        Huffman.IO.get_text_and_frequencies(filepath, filename, filetype, filter_fn)
      end)
      |> Statistics.generate_multisample_statistical_data(benchmark)

    analysed_files = filenames |> Enum.map(fn filename ->
      "#{filepath}/#{filename}.#{filetype}"
    end)
    |> Enum.join("\n")

    output = """
            Report for multiple files

            Average text length: #{data.text_length |> Float.round(2)} (considered characters)

            Average entropy: #{data.entropy |> Float.round(2)}
            Average average code length: #{data.average_code_length |> Float.round(2)}
            Average En-freq* avg. code length: #{data.average_code_length_en_freq |> Float.round(2)}

            ====== Average Code Savings ======
            Compared to UTF-8: #{data.utf8_savings |> Float.round(2)}%
            Compared to ASCII: #{data.ascii_savings |> Float.round(2)}%
            Compared to EN-freq*: #{data.generic_savings |> Float.round(2)}%
            ==================================

            #{Huffman.NTM.generate_report(data.runtimes)}

            ====== Analysed files ======
            #{analysed_files}
            ============================

            * EN-freq is a Huffman encoding based on the frequency distribution of
            characters in English language texts, created for this project.
            """

    output
  end
end
