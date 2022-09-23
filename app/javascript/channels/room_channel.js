import consumer from "./consumer"
import { add_typing, remove_typing } from '../custom/typing';
import { init_chat_display } from "../custom/message";


document.addEventListener('turbolinks:load', () => {
  const room = document.getElementById('room');
  const room_id = Number(room.getAttribute('data-room-id'));

  consumer.subscriptions.create({ channel: "RoomChannel", room_id: room_id }, {
    connected() {
      console.log("Connected to room " + room_id)
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const current_user_id = Number(room.getAttribute('data-user-id'));
      switch (data.category) {
        case 'message':
          if (current_user_id !== data.message.user_id) {
            remove_typing(data.username)
            add_html(data.html);
            init_chat_display();
            window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' })
          } else {
            const new_message = document.getElementById(data.message.id);
            const message_status = new_message.getElementsByClassName('status')[0]
            message_status.setAttribute('data-status', 'sent')
            message_status.setAttribute('data-status', 'delivered') // Move to diff function
          }
          break;
        case 'typing':
          if (current_user_id !== data.user_id) {
            if (data.typing) {
              add_typing(data.username)
            } else {
              remove_typing(data.username)
            }
          }
          break;
        default:
      }
      
    }
  });


  function add_html(html) {
    const messageContainer = document.getElementById('messages')
    messageContainer.innerHTML = messageContainer.innerHTML + html
  }


})

