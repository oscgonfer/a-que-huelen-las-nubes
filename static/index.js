const inbox = document.getElementById("inbox");
const outbox = document.getElementById("outbox");
const formField = document.getElementById("form-field");
const form = document.getElementById("form");

const TIMEOUT = 1000;

var ws; // Global variable
var connected = false;

window.addEventListener("load", (event) => {
  let date = new Date();
  console.log(date.get);
  console.log("page is fully loaded");
  $("#issue-date").text($('<div/>').text(`${daysInCatalan[date.getDay()]}, ${date.getUTCDate()} ${monthsInCatalan[date.getMonth()+1]}, ${date.getFullYear()}`).html());
});

function connect() {
  ws = new WebSocket("ws://0.0.0.0:8000");
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

    let potValue = parseFloat(msg.data);

    const
      scale = (fromRange, toRange) => {
        const d = (toRange[1] - toRange[0]) / (fromRange[1] - fromRange[0]);
        return from =>  (from - fromRange[0]) * d + toRange[0];
      };

    function getValues(myDict, trigger) {
      return myDict[((Object.keys(myDict)).filter(function(value){return value <= trigger;})).pop()]
    }

    // Main-article-img
    let gs = scale([0, 255], [0, 100])(potValue);
    $('#main-article-img').css('filter', `grayscale(${gs}%)`);

    // Texts
    for (const [key, value] of Object.entries(definitions)) {
      console.log(key, getValues(value, potValue));

      // Option with just change
      // $(`#${key}`).text($('<div/>').text(getValues(value, potValue)).html());

      // Option with fade
      $(`#${key}`).animate({
        'opacity' : 0, 'filter': "blur(20px)"
      }, 500, function(){
        $(this).html(getValues(value, potValue)).animate({'opacity': 1, 'filter': "blur(0px)"}, 500);});

    }
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
