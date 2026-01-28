import { Socket } from "phoenix";

let socket = new Socket("/socket", { authToken: window.userToken });
socket.connect();
let channel = socket.channel("room:game_lobby", {});
let username = document.querySelector("#player_name");
let lobbyCode = document.querySelector("#lobby_code");
let joinLobbyBtn = document.querySelector("#join-lobby-btn");
let createLobbyBtn = document.querySelector("#create-lobby-btn");

username.addEventListener("keypress", (event) => {
  if (lobbyCode.textContent.length > 0 && username.textContent.length > 0) {
    joinLobbyBtn.disabled = false;
  } else {
    joinLobbyBtn.disabled = true;
  }

  if (username.textContent.length > 0) {
    createLobbyBtn.disabled = false;
  } else {
    createLobbyBtn.disabled = true;
  }
});

lobbyCode.addEventListener("keypress", (event) => {
  if (lobbyCode.textContent.length > 0 && username.textContent.length > 0) {
    joinLobbyBtn.disabled = false;
  } else {
    joinLobbyBtn.disabled = true;
  }
});

lobbyCode.addEventListener("keypress", (event) => {
  if (event.key === "Enter") {
    if (lobbyCode.value.length > 0 && username.value.length > 0) {
      channel.push("join_game", {
        username: username.value,
        lobbyCode: lobbyCode.value,
      });
    }
  }
});

joinLobbyBtn.addEventListener("click", () => {
  channel
    .push("join_game", {
      username: username.value,
      lobbyCode: lobbyCode.value,
    })
    .receive("ok", (resp) => {
      console.log("Joined successfully", resp.message);
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
    });
});

// channel.on("new_player", (payload) => {
//   let message = document.createElement("p");
//   message.innerText = `[${Date()}] ${payload.body}`;
//   messageContainer.appendChild(message);
// });

channel
  .join()
  .receive("ok", (resp) => {
    console.log("Joined successfully", resp.message);
  })
  .receive("error", (resp) => {
    console.log("Unable to join", resp);
  });

export default socket;
