defmodule Pythia.Query do
  import Ecto.Query
  alias Pythia.Data
  use Ecto.Schema

  def split_string(query) do
  String.split(query, " ")
  |> Enum.map(fn x -> database_search(x) end)
  |> List.flatten
  |> Enum.uniq
  end

  defp database_search(keyword) do
    Pythia.Repo.all(from d in Data, select: d)
    |> Enum.map(fn x -> if (search_parameters(x, keyword)) do x end end)
    |> Enum.drop_while(fn x -> x == nil end)
  end

  defp includes_query(data, query) do
    if data != nil, do: String.contains?(String.downcase(data), query)
  end

  defp search_parameters(data, keyword) do
    [data.title, data.description, data.url]
    |> Enum.map(&includes_query(&1, keyword))
    |> IO.inspect
    |> Enum.any?(&(&1 == true))
    # (includes_query(data.title, keyword) || includes_query(data.description, keyword) || includes_query(data.url, keyword))
  end
end
