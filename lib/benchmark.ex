defmodule Huffman.Benchmark do
  @moduledoc """
  Primitive benchmarking module to measure encoding speed.
  """

  @doc """
  Runs a function `times` times, measuring execution time.
  Returns average of run times in microseconds.
  """
  @spec avg_runtime(any, integer) :: float
  def avg_runtime(function, times \\ 10) do
    0..times
    |> Enum.map(fn _n ->
      measure(function)
    end)
    |> Kernel.then(fn res ->
      Enum.sum(res) / length(res)
    end)
  end

  defp measure(function) do
    function
    |> :timer.tc
    |> elem(0)
  end
end
