defmodule Liverpool.LobbyManager do
  use GenServer

  # Called from Channel
  def start_link(lobby_code) do
    GenServer.start_link(__MODULE__, lobby_code, name: :lobby_manager)
  end

  def add_player(lobby_code, player_name) do
    IO.puts("Adding player to lobby: #{player_name}")
    GenServer.call(via_tuple(lobby_code), {:add_player, player_name})
  end

  def get_players(lobby_code) do
    GenServer.call(via_tuple(lobby_code), :get_players)
  end

  # Server Callbacks
  def init(state), do: {:ok, state}

  def handle_call({:add_player, player_name}, _from, state) do
    new_state = %{state | players: [player_name | state.players]}
  end

  defp via_tuple(lobby_code) do
    {:via, Registry, {Liverpool.LobbyRegistry, lobby_code}}
  end
end
