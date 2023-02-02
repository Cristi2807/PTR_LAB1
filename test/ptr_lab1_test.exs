defmodule PtrLab1Test do
  use ExUnit.Case
  doctest PtrLab1

  test "greets the PTR" do
    assert PtrLab1.hello() == :hello_ptr
  end
end
