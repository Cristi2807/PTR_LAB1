defmodule LinkedList do
  def create_dllist([head | tail]) do
    pid = spawn(fn -> loop(head, nil, nil) end)
    pid |> send({:append, tail})
    pid
  end

  def loop(value, left, right) do
    receive do
      {:append, []} ->
        loop(value, left, right)

      {:append, [head | tail]} ->
        pidNext = spawn(fn -> loop(head, self(), nil) end)
        pidNext |> send({:append, tail})
        loop(value, left, pidNext)

      {:traverse, pid, list} when right == nil ->
        send(pid, {:ok, list ++ [value]})
        loop(value, left, right)

      {:traverse, pid, list} ->
        send(right, {:traverse, pid, list ++ [value]})
        loop(value, left, right)

      {:inverse, pid, list} when right == nil ->
        send(pid, {:ok, [value | list]})
        loop(value, left, right)

      {:inverse, pid, list} ->
        send(right, {:inverse, pid, [value | list]})
        loop(value, left, right)
    end
  end

  def traverse(pid) do
    pid |> send({:traverse, self(), []})

    receive do
      {:ok, list} ->
        list
    end
  end

  def inverse(pid) do
    pid |> send({:inverse, self(), []})

    receive do
      {:ok, list} ->
        list
    end
  end
end
