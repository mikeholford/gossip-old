async function whisper(url, data, error_msg, type='POST') {
  return new Promise((resolve, reject) => {
    fetch(url, {method: 'POST', headers: { "Content-Type": "application/json; charset=utf-8" }, body: JSON.stringify(data) })
    .then(res => res.json()) // parse response as JSON (can be res.text() for plain response)
    .then(response => {
        resolve(response);
    })
    .catch(err => {
        say(error_msg);
        reject(error_msg);
    });
  })
}

function say(x) {
  console.log('---- SAY: ', x)
}

