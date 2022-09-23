import { whisper } from '../custom/helpers';

const initSender = () => {

  const container = document.getElementById('room');

  if (container) {

    const account_slug = container.getAttribute('data-account-slug')
    const room_id = Number(container.getAttribute('data-room-id'));
    const user_id = Number(container.getAttribute('data-user-id'));
    const role = container.getAttribute('data-role')

    const form = document.querySelector("#new_message")
    const chat_box = document.getElementById('chat-box')

    var countdown = null;

    // Trigger typing 
    chat_box.oninput = () => { start_typing(); }

    // Add message to body
    form.addEventListener("submit", function (e) {

      const body = chat_box.value;

      if (body === "") {
        e.preventDefault()
      } else {

        stop_typing()

        const placeholder = document.getElementById('message-template').firstElementChild
        const new_message = placeholder.cloneNode(true);

        new_message.classList.remove("placeholder");

        new_message.id = Math.random().toString(36).slice(2)
        new_message.getElementsByClassName('body')[0].innerHTML = body
        document.querySelector("#message_reference").value = new_message.id

        const messageContainer = document.getElementById('messages');
        messageContainer.innerHTML = messageContainer.innerHTML + new_message.outerHTML;

        init_chat_display();

        window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' })

        setTimeout(function () { form.reset(); }, 100);
      }

    });

    async function start_typing() {
      reset_typing_countdown()
      await whisper("/" + account_slug + "/rooms/" + room_id + "/messages/typing", { room_id: room_id, user_id: user_id, role: role, typing: true }, "Error fetching activity")
    }

    async function stop_typing() {
      await whisper("/" + account_slug + "/rooms/" + room_id + "/messages/typing", { room_id: room_id, user_id: user_id, typing: false }, "Error fetching activity")
    }

    function reset_typing_countdown() {
      if (countdown) { clearTimeout(countdown); }
      countdown_timer();
    }

    // Adjust the countdown time to change the length of time the user is considered typing
    function countdown_timer() {
      countdown = setTimeout(function () { stop_typing() }, 3000)
    }

  }
}

export function init_chat_display() {

  const components = document.querySelectorAll(".message-wrapper:not(.placeholder)");

  Array.from(components).forEach(function (component, index) {
    // console.log(component);

    const message = component.querySelector('.message')
    const avatar = component.querySelector('.avatar')

    if (index > 0) {
      if (components[index - 1].dataset.userId == component.dataset.userId) {
        message.classList.add("has-prev");
      }
    }

    if (index < components.length - 1) {
      if (components[index + 1].dataset.userId == component.dataset.userId) {
        component.classList.remove("mb-2");
        message.classList.add("has-next");
        if (avatar) { avatar.style.visibility = 'hidden' }
      }
    }

  });
}


export { initSender };
