export async function whisper(url, data, error_msg, type = 'POST') {
    return new Promise((resolve, reject) => {
        fetch(url, { method: 'POST', headers: { "Content-Type": "application/json; charset=utf-8" }, body: JSON.stringify(data) })
            .then(res => res.json()) // parse response as JSON (can be res.text() for plain response)
            .then(response => {
                resolve(response);
            })
            .catch(err => {
                console.log(error_msg);
                reject(error_msg);
            });
    })
}

export function htmlToElement(html) {
    var template = document.createElement('template');
    html = html.trim(); // Never return a text node of whitespace as the result
    template.innerHTML = html;
    return template.content.firstChild;
}
