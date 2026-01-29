defmodule LiverpoolWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:game_lobby", _message, socket) do
    {:ok, %{message: "Welcome to Liverpool Rummy"}, socket}
  end

  def handle_in("join_game", %{"username" => newPlayer, "lobbyCode" => lobbyCode}, socket) do
    case start_lobby_if_needed(lobbyCode) do
      {:ok, lobby_pid} ->
        Liverpool.LobbyManager.add_player(lobbyCode, newPlayer)
        broadcast!(socket, "new_player", %{body: newPlayer})
        {:reply, {:ok, %{message: "Waiting for host to start game"}}, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  defp start_lobby_if_needed(code) do
    case Registry.lookup(Liverpool.LobbyRegistry, code) do
      [] -> Liverpool.LobbyManager.start_link(code)
      [{pid, _}] -> {:ok, pid}
    end
  end

  def handle_in("get_players", %{"lobbyCode" => lobbyCode}, socket) do
    players = Liverpool.LobbyManager.get_players(lobbyCode)
    {:reply, {:ok, %{players: players}}, socket}
  end

  def join("room:" <> _room_id, _message, socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
