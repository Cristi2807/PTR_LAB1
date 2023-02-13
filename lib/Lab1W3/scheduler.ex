defmodule Scheduler do
  def create_scheduler() do
    spawn(fn -> loopScheduler(nil) end)
  end

  def loopScheduler(pid) do
    _ref = Process.monitor(pid)

    receive do
      {:job, _} ->
        loopScheduler(job())

      {:DOWN, _ref, :process, _pid, :failure} ->
        IO.puts("Task failed.")
        loopScheduler(job())
    end
  end

  def job() do
    spawn(fn ->
      case :rand.uniform(2) do
        1 -> Process.exit(self(), :failure)
        2 -> IO.puts("Task succeded: MIAU")
      end
    end)
  end
end
