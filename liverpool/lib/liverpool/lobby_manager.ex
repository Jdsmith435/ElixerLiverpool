defmodule Liverpool.LobbyManager do
  use GenServer

  # Called from Channel
  def start_link() do
    lobby_code =
      :crypto.strong_rand_bytes(6)
      |> Base.url_encode64(padding: false)
      |> binary_part(0, 8)

    GenServer.start_link(__MODULE__, lobby_code, name: via_tuple(lobby_code))
    {:ok, lobby_code}
  end

  def add_player(lobby_code, player_name) do
    GenServer.call(via_tuple(lobby_code), {:add_player, player_name})
    {:ok, %{players: GenServer.call(via_tuple(lobby_code), :get_players)}}
  end

  def get_players(lobby_code) do
    GenServer.call(via_tuple(lobby_code), :get_players)
  end

  # Server Callbacks
  def init(state), do: {:ok, %{players: [], lobby_code: state}}

  def handle_call({:add_player, player_name}, _from, state) do
    new_state = %{state | players: [player_name | state.players]}
    {:reply, :ok, new_state}
  end

  def handle_call(:get_players, _from, state) do
    {:reply, state.players, state}
  end

  # Gets the identifier for the lobby process
  defp via_tuple(lobby_code) do
    {:via, Registry, {Liverpool.LobbyRegistry, lobby_code}}
  end
end
