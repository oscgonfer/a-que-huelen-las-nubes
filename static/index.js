const inbox = document.getElementById("inbox");
const outbox = document.getElementById("outbox");
const formField = document.getElementById("form-field");
const form = document.getElementById("form");

function addLiChild(parent, content) {
  let liChild = document.createElement("li");
  liChild.textContent = content;
  parent.appendChild(liChild);
}

const TIMEOUT = 1000;

var ws; // Global variable
var connected = false;
function connect() {
  ws = new WebSocket("ws://localhost:8000");
  ws.addEventListener("open", ev => {
    connected = true;
    console.log(`Connection opened: ${ev}`);
  });
  ws.addEventListener("error", ev => {
    connected = false;
    //console.log(`Error from websocket! ${ev}\nTrying to reconnect...`);
    console.log(`Error from websocket! Closing...`)
    ws.close();
    //setTimeout(connect, TIMEOUT);
  });
  ws.addEventListener("close", ev => {
    connected = false;
    console.log(`Connection closed. Trying to reconnect...`);
    ws.close();
    setTimeout(connect, TIMEOUT);
  });
  ws.addEventListener("message", msg => {
    addLiChild(inbox, msg.data);
  });
}

function sendFromForm(event) {
  if (connected) {
    ws.send(formField.value);
    addLiChild(outbox, formField.value);
  } else {
    console.log("Not connected!");
  }
  event.preventDefault();
  return false;
}

connect();
form.addEventListener("submit", sendFromForm);