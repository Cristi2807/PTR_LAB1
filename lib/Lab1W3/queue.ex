defmodule Queue do
  use Agent

  def new_queue(queue \\ []) do
    Agent.start_link(fn -> queue end)
  end

  def push(pid, item) do
    Agent.update(pid, fn queue -> queue ++ [item] end)
  end

  def show(pid) do
    Agent.get(pid, fn queue -> queue end)
  end

  def pop(pid) do
    Agent.get_and_update(pid, fn queue ->
      case queue do
        [] ->
          {:err, []}

        [item | rest] ->
          {item, rest}
      end
    end)
  end
end
