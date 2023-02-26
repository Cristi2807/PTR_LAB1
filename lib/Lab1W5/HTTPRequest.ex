defmodule Lab1W5.HTTPRequest do
  use HTTPoison.Base
  import Floki

  def makeRequest() do
    response = get!("https://quotes.toscrape.com/")
    status_code = response.status_code
    headers = response.headers
    body = response.body

    IO.puts("Status code: #{status_code}")
    IO.puts("Headers: #{inspect(headers)}")
    IO.puts("Body : #{inspect(body)}")

    content =
      parse_document!(body)
      |> find("div.quote")
      |> Enum.map(fn oneQuote ->
        %{
          :quote =>
            find(oneQuote, ".text")
            |> text(),
          :author =>
            find(oneQuote, ".author")
            |> text(),
          :tags =>
            find(oneQuote, ".tag")
            |> Enum.map(&text/1)
        }
      end)
      |> Poison.encode!()

    File.write!("./lib/Lab1W5/quotes.json", content)
  end
end
