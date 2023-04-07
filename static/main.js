const socket = io.connect('http://' + document.domain + ':' + location.port);

socket.on('connect', () => {
    console.log('Connected');
});

socket.on('message', (msg) => {
    const li = document.createElement('li');
    li.innerHTML = msg;
    document.getElementById('messages').appendChild(li);
});

function sendMessage() {
    const input = document.getElementById('message');
    const message = input.value;
    input.value = '';
    socket.emit('message', message);
}
