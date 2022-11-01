defmodule Pgdemo.Synchronization do
  use GenServer

  @topic {:sync_demo, __MODULE__}

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def topic, do: @topic

  def init([]) do
    :pg.join(:internal_channel, self())
    {ref, pid} = :pg.monitor(:internal_channel)

    IO.inspect(ref)
    IO.inspect(pid)
    {:ok, []}
  end

  def update(some_param) do
    :pg.get_members(:internal_channel)
    |> Kernel.--(:pg.get_local_members(:internal_channel))
    |> Enum.each(fn pid ->
      IO.puts("Sending update on #{inspect(@topic)} to #{inspect(pid)}")
      send(pid, {:broadcast, @topic, {:update, some_param}})
    end)
  end

  def handle_info({:broadcast, @topic, {:update, some_param}}, state) do
    IO.puts("Received update on #{inspect(@topic)} with data:}")
    IO.inspect(some_param)
    {:noreply, state}
  end

  def handle_info({ref, join, group, pids}, state) do
    IO.inspect("LEULEU")
    IO.inspect(ref)
    IO.inspect(join)
    IO.inspect(group)
    IO.inspect(pids)

    {:noreply, state}
  end

  def handle_info(dt, state) do
    IO.inspect("LEULEU 2")
    IO.inspect(dt)

    {:noreply, state}
  end
end
