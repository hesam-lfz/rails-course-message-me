import consumer from "./consumer"


// Scroll to last message in the chats:
const scrollToLastChat = () => {
  const $msgsContainer = document.querySelector('#chatroom-messages-container');
  $msgsContainer.scroll({
    top: $msgsContainer.scrollHeight,
    behavior: 'smooth'
  });
}

consumer.subscriptions.create("ChatroomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    // Alow submit chat message via ENTER key:
    const $chatSubmitButton = document.querySelector('#chat-submit-comment');
    $chatSubmitButton.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        // Prevent the default behavior (e.g., creating a new line in the textarea)
        e.preventDefault();
        e.target.closest('form').submit();
      }
    });
    scrollToLastChat();
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const $msgsContainer = document.querySelector('#chatroom-messages-container');
    const $form = document.querySelector('#chatroom-form');
    $form.reset();
    $msgsContainer.insertAdjacentHTML('beforeend', data.body);
    scrollToLastChat();
  }
});
