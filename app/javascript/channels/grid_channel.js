import consumer from "./consumer"

consumer.subscriptions.create("GridChannel", {
  
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    var showgen = document.getElementById('showgen');
    showgen.innerHTML = data.gen;

    var showgrid = document.getElementById('showgrid');
    showgrid.innerHTML = data.grid;

  }

});