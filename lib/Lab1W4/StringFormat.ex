defmodule Lab1W4.StringFormat do
  def startStringFormat() do
    pid = spawn(fn -> loopSupervisor({%{}, [], nil}) end)
    send(pid, :start)

    pid
  end

  def loopSupervisor({workersMap, newWorkers, string}) do
    newWorkers
    |> Enum.map(&Process.monitor/1)

    receive do
      {:job, value} when is_binary(value) ->
        IO.puts("Job received. Sending to Worker1.")
        send(Map.get(workersMap, :Worker1), {:job, value})
        loopSupervisor({workersMap, [], value})

      {:job, _value} ->
        IO.puts("Not a string introduced. Try again with a string!")
        loopSupervisor({workersMap, [], nil})

      {:DOWN, _ref, :process, _monitoredPid, :error} when string == nil ->
        IO.puts("Error encountered, restarting all workers.")
        workersMap = restartAll(workersMap)

        newWorkers = [
          Map.get(workersMap, :Worker1),
          Map.get(workersMap, :Worker2),
          Map.get(workersMap, :Worker3)
        ]

        loopSupervisor({workersMap, newWorkers, nil})

      {:DOWN, _ref, :process, _monitoredPid, :error} ->
        IO.puts("Error encountered, restarting all workers and sending job again to Worker1.")
        workersMap = restartAll(workersMap)

        newWorkers = [
          Map.get(workersMap, :Worker1),
          Map.get(workersMap, :Worker2),
          Map.get(workersMap, :Worker3)
        ]

        send(Map.get(workersMap, :Worker1), {:job, string})
        loopSupervisor({workersMap, newWorkers, string})

      :ok ->
        IO.puts("As supervisor, I got info from Worker 3 that job is done!")
        loopSupervisor({workersMap, [], nil})

      :start ->
        IO.puts("Starting and monitoring the 3 workers.")
        workersMap = Map.put(workersMap, :Worker3, startWorker3(self()))
        workersMap = Map.put(workersMap, :Worker2, startWorker2(Map.get(workersMap, :Worker3)))
        workersMap = Map.put(workersMap, :Worker1, startWorker1(Map.get(workersMap, :Worker2)))
        IO.inspect(workersMap)

        newWorkers = [
          Map.get(workersMap, :Worker1),
          Map.get(workersMap, :Worker2),
          Map.get(workersMap, :Worker3)
        ]

        loopSupervisor({workersMap, newWorkers, nil})
    end
  end

  def restartAll(workersMap) do
    Process.exit(Map.get(workersMap, :Worker1), :kill)
    Process.exit(Map.get(workersMap, :Worker2), :kill)
    Process.exit(Map.get(workersMap, :Worker3), :kill)

    workersMap = Map.put(workersMap, :Worker3, startWorker3(self()))
    workersMap = Map.put(workersMap, :Worker2, startWorker2(Map.get(workersMap, :Worker3)))
    workersMap = Map.put(workersMap, :Worker1, startWorker1(Map.get(workersMap, :Worker2)))

    IO.inspect(workersMap)
    workersMap
  end

  defp startWorker1(pidNext) do
    spawn(fn -> loopWorker1(pidNext) end)
  end

  defp loopWorker1(pidNext) do
    receive do
      {:job, value} ->
        send(pidNext, {:job, jobWorker1(value)})
        loopWorker1(pidNext)
    end
  end

  defp jobWorker1(value) do
    String.split(value, ~r/\s+/)
  end

  defp startWorker2(pidNext) do
    spawn(fn -> loopWorker2(pidNext) end)
  end

  defp loopWorker2(pidNext) do
    receive do
      {:job, value} ->
        send(pidNext, {:job, jobWorker2(value)})
        loopWorker2(pidNext)
    end
  end

  defp jobWorker2(value) do
    value
    |> Enum.map(fn word ->
      word
      |> String.downcase()
      |> String.replace("m", "_")
      |> String.replace("n", "m")
      |> String.replace("_", "n")
    end)
  end

  defp startWorker3(pid) do
    spawn(fn -> loopWorker3(pid) end)
  end

  defp loopWorker3(pid) do
    receive do
      {:job, value} ->
        result = jobWorker3(value)
        IO.puts("Job done. Result: #{result}")
        send(pid, :ok)
        loopWorker3(pid)
    end
  end

  defp jobWorker3(value) do
    Enum.join(value, " ")
  end
end
