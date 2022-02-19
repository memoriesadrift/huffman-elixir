defmodule Huffman.Encodings do
  @moduledoc """
  Provides some sample encodings and text filtering functions to work with.
  """

  defmodule EN_Freq do
    @moduledoc """
    An encoding based on the frequencies given by Robert L. Solso and Joseph F. King for letters
    and Kun Sun and Rong Wang for punctuation. Based on frequencies per million words, the former
    in a sample of "roughly one million" the latter across multiple corpuses.
    Encoding matches the regular expression `~r/[a-z ,.()?:!';-]/`
    """
    @spec filter_fn(String.t()) :: boolean
    def filter_fn(e) do
      e =~ ~r/[a-zA-Z ,.()?:!';-]/
    end

    @spec encoding :: map
    def encoding() do
      %{
        "k" => "11011001",
        "w" => "101000",
        "'" => "11011000100",
        "i" => "0111",
        "v" => "1011001",
        "q" => "0101100111",
        "g" => "101001",
        "," => "1011000",
        "e" => "001",
        "c" => "01010",
        "!" => "01011000001",
        "l" => "10111",
        ":" => "11011000101",
        "z" => "0101100010",
        "a" => "1000",
        "p" => "101101",
        "f" => "110100",
        "h" => "0000",
        ";" => "01011000000",
        "r" => "0001",
        "-" => "110110000",
        "(" => "0101100110",
        " " => "111",
        "j" => "1101100011",
        "o" => "1001",
        "." => "0101101",
        "u" => "110111",
        "s" => "0100",
        "?" => "0101100001",
        "n" => "0110",
        "b" => "1101101",
        ")" => "0101100011",
        "y" => "010111",
        "t" => "1100",
        "m" => "110101",
        "x" => "010110010",
        "d" => "10101"
      }
    end
  end
end
