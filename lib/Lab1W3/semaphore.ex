defmodule Semaphore do
  def create_semaphore(count) do
    Agent.start_link(fn -> {count, []} end)
  end

  def acquire(pid) do
    pidSender = self()

    res =
      Agent.get_and_update(pid, fn {count, queue} ->
        if count > 0, do: {:ok, {count - 1, queue}}, else: {:error, {0, queue ++ [pidSender]}}
      end)

    case res do
      :ok ->
        :ok

      :error ->
        IO.inspect("Failed to acquire semaphore from: #{:erlang.pid_to_list(self())}")

        receive do
          :ok -> :ok
        end
    end
  end

  def release(pid) do
    Agent.update(pid, fn {count, queue} ->
      if length(queue) > 0 do
        [head | tail] = queue
        send(head, :ok)
        {count, tail}
      else
        {count + 1, queue}
      end
    end)
  end
end
