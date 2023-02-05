defmodule PtrLab1W2 do
  @pi 3.14159265

  def isPrime?(n) when n <= 1, do: false
  def isPrime?(n), do: isPrime?(n, 2)

  defp isPrime?(n, i) do
    cond do
      n == i -> true
      rem(n, i) == 0 -> false
      true -> isPrime?(n, i + 1)
    end
  end

  def cylinderArea(h, r) when h <= 0 or r <= 0, do: :not_real_dimensions

  def cylinderArea(h, r) do
    Float.round(2 * @pi * r * (r + h), 4)
  end

  def reverse(list) do
    reverse_list(list, [])
  end

  defp reverse_list([head | tail], acc) do
    reverse_list(tail, [head | acc])
  end

  defp reverse_list([], acc), do: acc

  def sum_unique(list) do
    sum_list(unique(list), 0)
  end

  def sum_list([head | tail], acc) do
    sum_list(tail, head + acc)
  end

  def sum_list([], acc), do: acc

  def unique(list) do
    unique_list(list, [])
  end

  defp unique_list([head | tail], acc) do
    if not Enum.member?(acc, head) do
      unique_list(tail, [head | acc])
    else
      unique_list(tail, acc)
    end
  end

  defp unique_list([], acc), do: acc

  def extractRandomN(list, n) do
    extractRandom(list, n, [])
  end

  def extractRandom(list, n, acc) do
    if length(acc) == n do
      acc
    else
      random_index = :rand.uniform(length(list) - 2) + 1
      random_element = Enum.at(list, random_index)
      extractRandom(list, n, [random_element | acc])
    end
  end

  def firstFibonacciElements(0), do: []
  def firstFibonacciElements(1), do: [1]
  def firstFibonacciElements(2), do: [1, 1]

  def firstFibonacciElements(n) do
    firstFibonacciElements(n - 1) ++
      [List.last(firstFibonacciElements(n - 1)) + List.last(firstFibonacciElements(n - 2))]
  end

  def translator(dictionary, sentence) do
    words = String.split(sentence, " ", trim: true)

    translatedWords =
      Enum.map(words, fn word ->
        case Map.get(dictionary, word) do
          nil -> word
          translatedWord -> translatedWord
        end
      end)

    Enum.join(translatedWords, " ")
  end

  def all_zeros?(list) do
    Enum.all?(list, &(&1 == 0))
  end

  def smallestNumber(list) do
    cond do
      Enum.all?(list, &(&1 == 0)) -> :not_possible
      true -> processDigits(list)
    end
  end

  def processDigits(list) do
    sortedDigits = Enum.sort(list, :asc)

    firstNonZeroIndex = Enum.find_index(sortedDigits, &(&1 != 0))
    value = Enum.at(sortedDigits, firstNonZeroIndex)

    String.to_integer(Enum.join([value] ++ List.delete_at(sortedDigits, firstNonZeroIndex)))
  end

  def rotateLeft(list, n) do
    len = length(list)
    n = rem(n, len)
    Enum.drop(list, n) ++ Enum.take(list, n)
  end

  def listRightAngleTriangles do
    1..20
    |> Enum.flat_map(fn a ->
      1..20
      |> Enum.map(fn b ->
        c = :math.sqrt(a * a + b * b)

        case trunc(c) == c do
          true ->
            {a, b, trunc(c)}

          false ->
            nil
        end
      end)
    end)
    |> Enum.filter(&(&1 != nil))
  end

  def removeConsecutiveDuplicates([head | tail]) do
    removeConsecutiveDuplicates(tail, [head])
  end

  def removeConsecutiveDuplicates([head | tail], acc) do
    [head1 | tail1] = acc

    case head === head1 do
      true ->
        removeConsecutiveDuplicates(tail, acc)

      false ->
        removeConsecutiveDuplicates(tail, [head, head1 | tail1])
    end
  end

  def removeConsecutiveDuplicates([], acc), do: Enum.reverse(acc)

  def lineWords(words) do
    words
    |> Enum.map(&String.trim(&1))
    |> Enum.filter(&oneLineWord?(&1))
  end

  def oneLineWord?(word) do
    word = word |> String.downcase() |> String.split("", trim: true)

    ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(fn row -> Enum.map(word, fn char -> char in row end) end)
    |> Enum.map(&Enum.all?(&1))
    |> Enum.any?()
  end

  def encode(word, k) do
    word
    |> String.downcase()
    |> String.split("", trim: true)
    |> Enum.map(fn letter -> computeLetter(letter, k, :+) end)
    |> Enum.join()
  end

  def decode(word, k) do
    word
    |> String.downcase()
    |> String.split("", trim: true)
    |> Enum.map(fn letter -> computeLetter(letter, k, :-) end)
    |> Enum.join()
  end

  def computeLetter(letter, k, sign) do
    alphabet = "abcdefghijklmnopqrstuvwxyz"

    letterIndex =
      alphabet
      |> String.graphemes()
      |> Enum.find_index(&(&1 == letter))

    case sign do
      :+ -> String.at(alphabet, rem(letterIndex + k, 26))
      :- -> String.at(alphabet, rem(letterIndex - k, 26))
    end
  end

  def letterCombinations(string) do
    dictionary = %{
      ?2 => 'abc',
      ?3 => 'def',
      ?4 => 'ghi',
      ?5 => 'jkl',
      ?6 => 'mno',
      ?7 => 'pqrs',
      ?8 => 'tuv',
      ?9 => 'wxyz'
    }

    letter_combinations_helper(string |> to_charlist, dictionary, [''])
    |> Enum.map(&to_string(&1))
  end

  defp letter_combinations_helper('', _dictionary, result), do: result

  defp letter_combinations_helper([head | tail], dictionary, result) do
    current = for list <- result, char <- dictionary[head], do: list ++ [char]
    letter_combinations_helper(tail, dictionary, current)
  end

  def groupAnagrams(list) do
    groupAnagramsHelper(list, %{})
  end

  defp groupAnagramsHelper([], map), do: map

  defp groupAnagramsHelper([head | tail], map) do
    key =
      head
      |> to_charlist()
      |> Enum.sort()
      |> to_string()

    keyList = Map.get(map, key, [])

    keyList =
      if head in keyList do
        keyList
      else
        keyList ++ [head]
      end

    groupAnagramsHelper(tail, Map.put(map, key, keyList))
  end

  def commonPrefix([]), do: ""

  def commonPrefix(strings) do
    [head | tail] = strings
    commonPrefixHelper(tail, head)
  end

  defp commonPrefixHelper([], prefix), do: prefix

  defp commonPrefixHelper([head | tail], prefix) do
    prefix =
      Enum.zip(head |> String.graphemes(), prefix |> String.graphemes())
      |> Enum.take_while(fn {a, b} -> a == b end)
      |> Enum.map(fn {a, a} -> a end)
      |> to_string()

    commonPrefixHelper(tail, prefix)
  end

  def toRoman(number) do
    dict = [
      [1000, "M"],
      [900, "CM"],
      [500, "D"],
      [400, "CD"],
      [100, "C"],
      [90, "XC"],
      [50, "L"],
      [40, "XL"],
      [10, "X"],
      [9, "IX"],
      [5, "V"],
      [4, "IV"],
      [1, "I"]
    ]

    toRomanHelper(number, "", dict)
  end

  defp toRomanHelper(0, res, _dict), do: res

  defp toRomanHelper(number, result, dict) do
    [n, roman] = Enum.find(dict, fn [n, _roman] -> number >= n end)

    toRomanHelper(number - n, result <> roman, dict)
  end

  def factorize(n) do
    factorizeHelper(n, [])
  end

  defp factorizeHelper(1, res), do: res

  defp factorizeHelper(n, list) do
    primeFactor =
      2..n
      |> Enum.find(fn i -> isPrime?(i) and rem(n, i) == 0 end)

    factorizeHelper(div(n, primeFactor), list ++ [primeFactor])
  end
end
