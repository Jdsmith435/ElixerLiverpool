defmodule LiverpoolWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:game_lobby", _message, socket) do
    {:ok, %{message: "Welcome to Liverpool Rummy"}, socket}
  end

  def handle_in("join_game", %{"username" => newPlayer, "lobbyCode" => lobbyCode}, socket) do
    broadcast!(socket, "new_player", %{body: newPlayer})
    {:reply, {:ok, %{message: "Waiting for host to start game"}}, socket}
  end

  def join("room:" <> _room_id, _message, socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
