defmodule Lab1W5.API.DataStore do
  use Agent

  def startDataStoreAgent() do
    Agent.start_link(
      fn ->
        {:ok, movies_json} = File.read("./lib/Lab1W5/movies.json")
        {:ok, state} = Poison.decode(movies_json)
        state
      end,
      name: __MODULE__
    )
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end

  def getByID(id) do
    Agent.get(__MODULE__, &Enum.find(&1, fn %{"id" => value} -> value == id end))
  end

  def post(title, release_year, director) do
    Agent.update(__MODULE__, fn state ->
      max_id = Enum.max_by(state, fn map -> map["id"] end)["id"]

      new_state =
        state ++
          [
            %{
              "title" => title,
              "release_year" => release_year,
              "id" => max_id + 1,
              "director" => director
            }
          ]

      File.write!("./lib/Lab1W5/movies.json", Poison.encode!(new_state))

      new_state
    end)
  end

  def put(id, title, release_year, director) do
    Agent.update(__MODULE__, fn state ->
      new_state =
        Enum.filter(state, fn %{"id" => value} -> id != value end) ++
          [
            %{
              "id" => id,
              "title" => title,
              "release_year" => release_year,
              "director" => director
            }
          ]

      File.write!("./lib/Lab1W5/movies.json", Poison.encode!(new_state))

      new_state
    end)
  end

  def patch(id, changes) do
    Agent.get_and_update(__MODULE__, fn state ->
      current =
        state
        |> Enum.find(fn %{"id" => value} -> id == value end)

      case current do
        nil ->
          {
            nil,
            state
          }

        _ ->
          new_state =
            Enum.filter(state, fn %{"id" => value} -> id != value end) ++
              [Map.merge(current, changes)]

          File.write!("./lib/Lab1W5/movies.json", Poison.encode!(new_state))

          {
            Map.merge(current, changes),
            new_state
          }
      end
    end)
  end

  def del(id) do
    Agent.get_and_update(__MODULE__, fn state ->
      new_state =
        state
        |> Enum.filter(fn %{"id" => value} -> id != value end)

      File.write!("./lib/Lab1W5/movies.json", Poison.encode!(new_state))

      {
        state |> Enum.find(fn %{"id" => value} -> id == value end),
        new_state
      }
    end)
  end
end

defmodule Lab1W5.API.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/movies" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Lab1W5.API.DataStore.get() |> Poison.encode!())
  end

  get "/movies/:id" do
    movie =
      conn.path_params["id"]
      |> String.to_integer()
      |> Lab1W5.API.DataStore.getByID()

    case movie do
      nil ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(404, "Not Found")

      movie ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, movie |> Poison.encode!())
    end
  end

  post "/movies" do
    {:ok, body, conn} = conn |> Plug.Conn.read_body()

    {:ok,
     %{
       "title" => title,
       "release_year" => release_year,
       "director" => director
     }} = body |> Poison.decode()

    Lab1W5.API.DataStore.post(title, release_year, director)

    send_resp(conn, 201, "")
  end

  put "/movies/:id" do
    id =
      conn.path_params["id"]
      |> String.to_integer()

    {:ok, body, conn} = conn |> Plug.Conn.read_body()

    {:ok,
     %{
       "title" => title,
       "release_year" => release_year,
       "director" => director
     }} = body |> Poison.decode()

    Lab1W5.API.DataStore.put(id, title, release_year, director)

    send_resp(conn, 200, "")
  end

  patch "/movies/:id" do
    id =
      conn.path_params["id"]
      |> String.to_integer()

    {:ok, body, conn} = conn |> Plug.Conn.read_body()

    {:ok, body} = body |> Poison.decode()

    movie = Lab1W5.API.DataStore.patch(id, body)

    case movie do
      nil ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(404, "Not Found")

      movie ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, movie |> Poison.encode!())
    end
  end

  delete "/movies/:id" do
    movie =
      conn.path_params["id"]
      |> String.to_integer()
      |> Lab1W5.API.DataStore.del()

    case movie do
      nil ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(404, "Not Found")

      movie ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, movie |> Poison.encode!())
    end
  end

  match _ do
    send_resp(conn, 400, "Route not handled!")
  end
end

defmodule Lab1W5.API.Main do
  def main do
    {:ok, _} = Lab1W5.API.DataStore.startDataStoreAgent()
    {:ok, _} = Plug.Cowboy.http(Lab1W5.API.Router, [], port: 8080)
    IO.puts("The server started on PORT 8080")
  end
end
