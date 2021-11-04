import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const room = document.getElementById('room');
  const room_id = Number(room.getAttribute('data-room-id'));

  consumer.subscriptions.create({ channel: "RoomChannel", room_id: room_id }, {
    connected() {
      console.log("Connected to room " + room_id)
      // Called when the subscription is ready for use on the server

      document.getElementById('chat-end').scrollIntoView();

    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const user_id = Number(room.getAttribute('data-user-id'));

      let html;

      if (user_id === data.message.user_id) {
        html = data.primary
      } else {
        html = data.default
      }
      
      const messageContainer = document.getElementById('messages')
      messageContainer.innerHTML = messageContainer.innerHTML + html

      document.getElementById('chat-end').scrollIntoView({ behavior: 'smooth', block: 'start' });

      
    }
  });

})

function htmlToElement(html) {
  var template = document.createElement('template');
  html = html.trim(); // Never return a text node of whitespace as the result
  template.innerHTML = html;
  return template.content.firstChild;
}
