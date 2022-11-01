defmodule Pgdemo.Application do
  use Application

  def start(_type, _args) do
    children = [
      %{
        id: :pg,
        start: {:pg, :start_link, []}
      },
      Pgdemo.Synchronization
    ]

    opts = [strategy: :one_for_one, name: Pgdemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
