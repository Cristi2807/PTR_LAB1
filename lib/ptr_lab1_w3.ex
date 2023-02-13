defmodule PtrLab1W3 do
  def startPrintLink() do
    spawn(fn -> printMessage() end)
  end

  defp printMessage() do
    receive do
      {:print, message} ->
        IO.puts(message)
        printMessage()
    end
  end

  def startPrintFormatLink() do
    spawn(fn -> printFormatMessage() end)
  end

  defp printFormatMessage() do
    receive do
      message when is_integer(message) ->
        IO.puts(message + 1)

      message when is_bitstring(message) ->
        IO.puts(message |> String.downcase())

      _ ->
        IO.puts("I do not know how to HANDLE this !")
    end

    printFormatMessage()
  end

  def startMonitoringActor(monitoredPid) do
    spawn(fn -> monitor(monitoredPid) end)
  end

  defp monitor(monitoredPid) do
    Process.monitor(monitoredPid)

    receive do
      {:DOWN, _ref, :process, _monitoredPid, reason} ->
        IO.puts("The monitored pid stopped with reason: #{reason}")
    end
  end

  def startAveragerActor() do
    spawn(fn -> average(0.0) end)
  end

  defp average(avg) do
    receive do
      value when is_integer(value) ->
        IO.puts("Current average is #{avg}")
        average((avg + value) / 2)

      _ ->
        IO.puts("Not a number inputed.")
        average(avg)
    end
  end

  def mutexExample() do
    {_, pid} = Semaphore.create_semaphore(1)
    spawn(fn -> mutexTask(pid) end)
    spawn(fn -> mutexTask(pid) end)
    spawn(fn -> mutexTask(pid) end)
    spawn(fn -> mutexTask(pid) end)
  end

  def mutexTask(pid) do
    Semaphore.acquire(pid)
    IO.inspect("Semaphore acquired from #{:erlang.pid_to_list(self())}")
    Process.sleep(3000)
    IO.inspect("Semaphore released from #{:erlang.pid_to_list(self())}")
    Semaphore.release(pid)
  end
end
