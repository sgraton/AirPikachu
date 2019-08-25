import consumer from "./consumer"

$(function() {
  consumer.subscriptions.create({ channel: "MessagesChannel", id: $('#conversation_id').val() }, {
    received(data) {
      $('#new_message')[0].reset();
      $('#chat').prepend(data.message);
    }
  })
});