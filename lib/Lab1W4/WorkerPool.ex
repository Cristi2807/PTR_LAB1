defmodule Lab1W4.WorkerPool do
  def startPrintLink() do
    pid = spawn(fn -> printMessage() end)
    IO.puts("A printing actor #{inspect(pid)} has been created.")
    pid
  end

  defp printMessage() do
    receive do
      {:print, message} ->
        IO.puts(message)
        printMessage()
    end
  end

  def startPool(n) do
    list =
      1..n
      |> Enum.map(fn _ -> startPrintLink() end)

    spawn(fn -> loopMonitor({list, list}) end)
  end

  def loopMonitor({list, newWorker}) do
    IO.puts("The list of actors I'm currently monitoring: #{inspect(list)}")

    newWorker
    |> Enum.map(&Process.monitor/1)

    receive do
      {:DOWN, _ref, :process, monitoredPid, :killed} ->
        IO.puts("Process #{inspect(monitoredPid)} got killed. Creating and monitoring new actor.")
        pid = startPrintLink()
        list = List.delete(list, monitoredPid) ++ [pid]
        loopMonitor({list, [pid]})
    end
  end
end
