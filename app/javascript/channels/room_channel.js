import consumer from "./consumer"
import { htmlToElement } from 'custom/helpers'
import { insertion } from 'custom/insertion'

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
      const user_id = Number(room.getAttribute('data-user-id'));

      switch (data.category) {
        case 'message':
          if (user_id !== data.message.user_id) {
            // Add message to receiving users thread
            remove_all_typing();
            add_html(data.html);
            window.scrollTo(0, document.body.scrollHeight);
          } else {
            // Update message status to delivered 
            setTimeout(function () {
              const new_message = document.getElementById(data.message.id);
              const message_status = new_message.getElementsByClassName('status')[0]
              message_status.setAttribute('data-status', 'sent')
              message_status.setAttribute('data-status', 'delivered') // Move to diff function
            }, 500);
          }
          break;
        case 'typing':
          if (user_id !== data.user_id) {
            add_typing(data.user_id, data.username, data.role)
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

  function add_typing(id, username, role) {
    // let new_typing
    var typing_element = document.getElementsByClassName('typing')[0]

    // new_typing = false

    // Set new typing users
    var users = typing_element.getAttribute('data-users')
    
    if (users) {
      var json_users = JSON.parse(users)
      if (!json_users.includes(id)){ json_users.push(id) }
    } else {
      json_users = [id]
    }
    typing_element.setAttribute('data-users', JSON.stringify(json_users))

    if (json_users.length === 1) {
      typing_element.querySelector("#names").innerHTML = username + " is typing..."
    } else if (json_users.length > 1) {
      typing_element.querySelector("#names").innerHTML = "Several people are typing..."
    }

    // if (new_typing) { add_html(typing_element.outerHTML) }

    // Set to remove after 3 seconds
    // setTimeout(function () { remove_user_typing(id) }, 3000);
  }

  function remove_user_typing(id) {
    var element = document.getElementsByClassName('typing')[0]
    if (element) {
      var users = element.getAttribute('data-users')
      if (users) {
        var json_users = JSON.parse(users)
        json_users.splice(json_users.indexOf(id), 1)
        element.setAttribute('data-users', JSON.stringify(json_users))
        show_hide_users(element, json_users)
        // if (json_users.length === 0) { element.remove() }
      }
    } else {
      console.log("Not found!")
    }
  }

  function show_hide_users(element, users) {
    if (users.length === 1) {
      element.querySelector("#names").innerHTML = username + " is typing..."
    } else if (users.length > 1) {
      element.querySelector("#names").innerHTML = "Several people are typing..."
    } else {
      element.querySelector("#names").innerHTML = "Nobody is typing..."
    }
  }

  function remove_all_typing() {
    document.querySelectorAll('.typing').forEach(e => e.remove());
  }

  insertion('.typing').every(function (element) {
    console.log("YAY TYPING!!!");
  });

})

