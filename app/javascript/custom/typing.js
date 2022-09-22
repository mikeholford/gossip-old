export function add_typing(username) {
    var element = document.getElementsByClassName('typing')[0]

    element.classList.remove("hidden");

    var users = element.getAttribute('data-users')    
    if (users) {
        var json_users = JSON.parse(users)
        if (!json_users.includes(username)){ json_users.push(username) }
    } else {
        var json_users = [username]
    }
    element.setAttribute('data-users', JSON.stringify(json_users))
    show_hide_users(element, json_users)
}


export function remove_typing(username) {
    var element = document.getElementsByClassName('typing')[0]
    if (element) {
        var users = element.getAttribute('data-users')
        if (users) {
            var json_users = JSON.parse(users)
            json_users.splice(json_users.indexOf(username), 1)
            element.setAttribute('data-users', JSON.stringify(json_users))
            show_hide_users(element, json_users)
            if (json_users.length === 0) { element.classList.add("hidden"); }
        }
    } else {
        console.log("Not found!")
    }
}

function show_hide_users(element, json_users) {
    if (json_users.length === 1) {
        element.querySelector("#names").innerHTML = json_users[0] + " is typing..."
    } else if (json_users.length > 1) {
        element.querySelector("#names").innerHTML = "Several people are typing..."
    } else {
        element.querySelector("#names").innerHTML = ""
    }
}