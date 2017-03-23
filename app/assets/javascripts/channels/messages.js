console.log("setting up messages channel", App.cable);

// first argument can be a string "MessagesChannel", or {channel: "MessagesChannel", room: "room name"}
// let's keep it simple for now
App.messages = App.cable.subscriptions.create("MessagesChannel", {
    connected: function() {
        console.log("connected");
        // Called when the subscription is ready for use on the server
    },
    disconnected: function() {
        console.log("disconnected");
        // Called when the subscription has been terminated by the server
    },
    received: function(data) {
        console.log({
            "data received": data
        });
        // Called when there's incoming data on the websocket for this channel
        $(".messages").append(data.message);
    },
    test: function(data) {
        // Notice that this calls the javascript defined by MessagesChannel#test on the server
        this.perform('test', {
            message: data
        });
    }
});
