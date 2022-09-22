import { whisper } from '../custom/helpers';

document.addEventListener('turbolinks:load', () => {
    
    const container = document.getElementById('room');
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

            var template = document.getElementById('message-template').firstElementChild

            template.id = Math.random().toString(36).slice(2)
            template.getElementsByClassName('body')[0].innerHTML = body
            document.querySelector("#message_reference").value = template.id

            var messageContainer = document.getElementById('messages');
            messageContainer.innerHTML = messageContainer.innerHTML + template.outerHTML;

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
    
})
