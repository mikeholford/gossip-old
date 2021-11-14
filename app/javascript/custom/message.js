import { whisper } from 'custom/helpers';

document.addEventListener('turbolinks:load', () => {
    const container = document.getElementById('room');
    const account_slug = container.getAttribute('data-account-slug')
    const room_id = Number(container.getAttribute('data-room-id'));
    const user_id = Number(container.getAttribute('data-user-id'));
    const role = container.getAttribute('data-role')

    const form = document.querySelector("#new_message")
    const chat_box = document.getElementById('chat-box')

    // Trigger typing 
    chat_box.oninput = () => {
        if (chat_box.getAttribute('data-typing') === 'false') {
            show_typing();
            chat_box.setAttribute('data-typing', 'true')
        }
    }

    // Add message to body
    form.addEventListener("submit", function (e) {

        const body = chat_box.value;

        if (body === "") {
            e.preventDefault()
        } else {

            var template = document.getElementById('message-template').firstElementChild
            

            template.id = Math.random().toString(36).slice(2)
            template.getElementsByClassName('body')[0].innerHTML = body
            document.querySelector("#message_reference").value = template.id

            var messageContainer = document.getElementById('messages');
            messageContainer.innerHTML = messageContainer.innerHTML + template.outerHTML;

            window.scrollTo(0, document.body.scrollHeight);

            setTimeout(function () { form.reset(); }, 100);
        }

    });

    async function show_typing(e) {
        let result
        result = await whisper("/" + account_slug + "/rooms/" + room_id + "/messages/typing", { room_id: room_id, user_id: user_id, role: role }, "Error fetching activity")
        if (result.typing) { console.log('Typing True') }
        setTimeout(function () { chat_box.setAttribute('data-typing', 'false') }, 2000);
    }
})
