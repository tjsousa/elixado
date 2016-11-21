defmodule Flaky do

  defmodule MyPlug do
    import Plug.Conn

    def init(options), do: options
    def call(conn, _opts) do
      case :rand.uniform do
        value when value >= 0.5 -> send_resp(conn, 200, "Hello world")
        _                       -> send_resp(conn, 500, "I'm a teapot")
      end
    end
  end


  def start do
    Elixado.start_link('./config/envoy.json')
    Plug.Adapters.Cowboy.http MyPlug, [], port: 8080

    IO.puts "Doing requests without elixado"
    load_test('localhost:8080')

    IO.puts "Doing requests WITH elixado"
    load_test('localhost:9211')
  end

  def load_test(target_url) do
    with \
      results <- map(target_url),
      frequencies <- reduce(results) do
      IO.puts "Results: #{frequencies |> inspect}"
    end
  end

  def map(target_url) do
    for n <- 1..100, {:ok, %HTTPoison.Response{status_code: status}} = HTTPoison.get(target_url), do: status
  end

  def reduce(results) do
    Enum.reduce(results, %{}, fn tag, acc -> Map.update(acc, tag, 1, &(&1 + 1)) end)
  end
end
