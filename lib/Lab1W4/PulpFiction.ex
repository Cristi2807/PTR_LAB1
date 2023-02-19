defmodule Lab1W4.PulpFiction do
  @questions %{
               1 => "What does Marcellus Wallace look like?",
               2 => "What country are you from?",
               3 => "What ain't no country I ever heard of! They speak English in What?",
               4 => "English, motherfucker! Do you speak it?",
               5 => "Then you know what I'm sayin'!",
               6 => "Describe what Marcellus Wallace looks like!",
               7 =>
                 "Say 'what' again! Say 'what' again! I dare you! I double dare you, motherfucker! Say 'what' one more goddamn time!",
               8 => "Go on!",
               9 => "Does he look like a bitch?"
             }
             |> Map.new()

  @answers %{
             1 => "What?",
             2 => "What?",
             3 => "What?",
             4 => "Yes! Yes!",
             5 => "Yes!",
             6 => "What?",
             7 => "He's black--",
             8 => "He's bald--",
             9 => "What?"
           }
           |> Map.new()

  def startJules() do
    pid = spawn(fn -> loopJules(1, nil) end)
    send(pid, :start)

    pid
  end

  defp loopJules(count, pid) do
    receive do
      :start ->
        Process.sleep(1500)
        IO.puts("Starting monitoring and questioning Brett")
        pid = startBrett(self())
        Process.monitor(pid)
        Process.sleep(700)
        IO.puts("Jules: #{@questions[count]}")
        send(pid, count)
        loopJules(count, pid)

      {:DOWN, _ref, :process, _monitoredPid, :what} ->
        Process.sleep(700)
        IO.puts("BOOOOOOOOOOM! OOPS, Brett got shot for WHAT saying ;))")
        Process.exit(self(), :finish)

      {:DOWN, _ref, :process, _monitoredPid, _reason} ->
        Process.sleep(500)
        IO.puts("Brett fainted. Waking him up and continuing...")
        Process.sleep(500)
        pid = startBrett(self())
        Process.monitor(pid)
        IO.puts("Jules: #{@questions[count]}")
        Process.sleep(1500)
        send(pid, count)
        loopJules(count, pid)

      :response ->
        Process.sleep(1500)
        count = count + 1
        IO.puts("Jules: #{@questions[count]}")
        Process.sleep(2000)
        send(pid, count)
        loopJules(count, pid)
    end
  end

  def startBrett(pid) do
    spawn(fn -> loopBrett(pid) end)
  end

  defp loopBrett(pid) do
    receive do
      value ->
        answer(value, pid)
        loopBrett(pid)
    end
  end

  def answer(count, _pid) when count == 9 do
    Process.sleep(2000)
    IO.puts("Brett: #{@answers[count]}")
    Process.exit(self(), :what)
  end

  def answer(count, pid) when count >= 7 do
    Process.sleep(2000)

    case :rand.uniform(3) do
      1 ->
        IO.puts("What?")
        Process.exit(self(), :what)

      _ ->
        IO.puts("Brett: #{@answers[count]}")
        send(pid, :response)
    end
  end

  def answer(count, pid) do
    Process.sleep(2000)

    case :rand.uniform(6) do
      1 ->
        Process.exit(self(), :failure)

      _ ->
        IO.puts("Brett: #{@answers[count]}")
        send(pid, :response)
    end
  end
end
