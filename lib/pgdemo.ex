defmodule Pgdemo do
  @moduledoc """
  Documentation for `Pgdemo`.
  """

  def connect() do
    # libcluster
    1..5
    |> Enum.map(fn i ->
      node = :"#{i}@127.0.0.1"
      {node, Node.connect(node)}
    end)
  end

  def update do
    Pgdemo.Synchronization.update(:test)
  end
end
