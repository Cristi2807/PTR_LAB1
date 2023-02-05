defmodule PtrLab1W2Test do
  use ExUnit.Case
  doctest PtrLab1W2

  test "Check the isPrime? function" do
    refute PtrLab1W2.isPrime?(1)
    refute PtrLab1W2.isPrime?(4)
    refute PtrLab1W2.isPrime?(6)
    refute PtrLab1W2.isPrime?(30)
    refute PtrLab1W2.isPrime?(10)

    assert PtrLab1W2.isPrime?(2)
    assert PtrLab1W2.isPrime?(3)
    assert PtrLab1W2.isPrime?(5)
    assert PtrLab1W2.isPrime?(7)
    assert PtrLab1W2.isPrime?(13)
  end

  test "Check cylinderArea function" do
    assert PtrLab1W2.cylinderArea(0, 4) == :not_real_dimensions
    assert PtrLab1W2.cylinderArea(3, 0) == :not_real_dimensions
    assert PtrLab1W2.cylinderArea(0, 0) == :not_real_dimensions

    assert PtrLab1W2.cylinderArea(3, 4) == 175.9292
    assert PtrLab1W2.cylinderArea(3, 6) == 339.2920
  end

  test "Check reverse function" do
    assert PtrLab1W2.reverse([]) == []

    assert PtrLab1W2.reverse([1]) == [1]
    assert PtrLab1W2.reverse([1, 2]) == [2, 1]
    assert PtrLab1W2.reverse([1, 2, 3]) == [3, 2, 1]
  end

  test "Check sum function" do
    assert PtrLab1W2.sum_unique([]) == 0

    assert PtrLab1W2.sum_unique([1, 2]) == 3
    assert PtrLab1W2.sum_unique([1, 1]) == 1
    assert PtrLab1W2.sum_unique([1, 1, 2]) == 3
    assert PtrLab1W2.sum_unique([1, 1, 2, 2, 3]) == 6
  end

  test "Check first Fibonacci numbers" do
    assert PtrLab1W2.firstFibonacciElements(0) == []

    assert PtrLab1W2.firstFibonacciElements(3) == [1, 1, 2]
    assert PtrLab1W2.firstFibonacciElements(5) == [1, 1, 2, 3, 5]
    assert PtrLab1W2.firstFibonacciElements(7) == [1, 1, 2, 3, 5, 8, 13]
    assert PtrLab1W2.firstFibonacciElements(10) == [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
  end

  test "Check translator " do
    dictionary = %{"mama" => "mother", "papa" => "father", "machina" => "car", "tu" => "you"}

    assert PtrLab1W2.translator(dictionary, "i am a student") == "i am a student"
    assert PtrLab1W2.translator(dictionary, "mama is with papa") == "mother is with father"

    assert PtrLab1W2.translator(dictionary, "mama and papa are in the machina with tu") ==
             "mother and father are in the car with you"
  end

  test "Check smallest number from digits" do
    assert PtrLab1W2.smallestNumber([0, 0, 0, 0]) == :not_possible
    assert PtrLab1W2.smallestNumber([0, 1]) == 10
    assert PtrLab1W2.smallestNumber([4, 5, 3]) == 345
    assert PtrLab1W2.smallestNumber([0, 4, 3]) == 304
    assert PtrLab1W2.smallestNumber([0, 0, 0, 0, 0, 0, 1, 2, 4, 4, 6]) == 10_000_002_446
  end

  test "Check removeConsecutiveDuplicates" do
    assert PtrLab1W2.removeConsecutiveDuplicates([1, 2, 2, 2, 4, 8, 4]) == [1, 2, 4, 8, 4]

    assert PtrLab1W2.removeConsecutiveDuplicates([1, 1, 1, 1, 1, 2, 2, 2, 3, 4, 4, 4]) == [
             1,
             2,
             3,
             4
           ]
  end

  test "Check lineWords" do
    assert PtrLab1W2.lineWords([" Hello ", " Alaska ", " Dad ", " Peace "]) == ["Alaska", "Dad"]

    assert PtrLab1W2.lineWords([]) == []
    assert PtrLab1W2.lineWords(["qaz", "cde", "tgb"]) == []
    assert PtrLab1W2.lineWords(["das", "trei", "bmx"]) == ["das", "trei", "bmx"]
  end

  test "Check Caesar" do
    assert PtrLab1W2.encode("lorem", 3) == "oruhp"
    assert PtrLab1W2.decode("oruhp", 3) == "lorem"

    assert PtrLab1W2.decode(PtrLab1W2.encode("abcdefghijklmnopqrstuvwxyz", 7), 7) ==
             "abcdefghijklmnopqrstuvwxyz"
  end
end
