import consumer from "./consumer"

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
            remove_all_typing()
            add_html(data.html)
            // Add message to receiving users thread
            // const messageContainer = document.getElementById('messages')
            // messageContainer.innerHTML = messageContainer.innerHTML + data.html
          } else {
            // Update message status to delivered 
            setTimeout(function () {
              const new_message = document.getElementById(data.message.id);
              const message_status = new_message.getElementsByClassName('status')[0]
              message_status.setAttribute('data-status', 'delivered')
            }, 500);
          }
          break;
        case 'typing':
          if (user_id !== data.user_id) {

            var typing = `<div class="w-full inline-block relative typing" id="">
                            <div class="float-left ml-1 mr-5 my-1" style="max-width: 75%;">
                                <div class=" relative table-cell bg-gray-300 px-2 py-4 rounded-lg" >
                                    <svg id="typing_bubble" data-name="typing bubble" xmlns="http://www.w3.org/2000/svg" width="24" height="6" viewBox="0 0 24 6">
                                        <defs>
                                            <style>
                                                .dot {fill: rgba(255, 255, 255, .7); transform-origin: 50% 50%; animation: ball-beat 1.1s 0s infinite cubic-bezier(0.445, 0.050, 0.550, 0.950);}
                                                .dot:nth-child(2) {animation-delay: 0.3s !important;}
                                                .dot:nth-child(3) {animation-delay: 0.6s !important;}
                                                @keyframes ball-beat {
                                                    0% 			{opacity: 0.7;}
                                                    33.33% 	{opacity: 0.55;}
                                                    66.67% 	{opacity: 0.4;}
                                                    100% 		{opacity: 1;}
                                                }
                                            </style>
                                        </defs>
                                        <g>
                                            <circle class="dot" cx="3" cy="3" r="3" />
                                            <circle class="dot" cx="12" cy="3" r="3" />
                                            <circle class="dot" cx="21" cy="3" r="3" />
                                        </g>
                                    </svg>
                                </div>
                            </div>
                          </div>`
                                              

            remove_all_typing()
            add_typing(typing)

            // setTimeout(function () {
            //   remove_typing()
            // }, 3000);


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

  function add_typing(html) {
    var typing_element = htmlToElement(html)
    var typing_id = Math.random().toString(36).slice(2)
    typing_element.id = typing_id
    add_html(typing_element.outerHTML)

    // Set to remove after 3 seconds
    setTimeout(function () {
      var ele = document.getElementById(typing_id)
      if (ele) { 
        ele.remove(); 
      } else {
        console.log("Not found!")
      }
    }, 5000);
  }

  function remove_all_typing() {
    document.querySelectorAll('.typing').forEach(e => e.remove());
  }

  function htmlToElement(html) {
    var template = document.createElement('template');
    html = html.trim(); // Never return a text node of whitespace as the result
    template.innerHTML = html;
    return template.content.firstChild;
  }

})

