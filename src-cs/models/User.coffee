Chat.User = Em.Object.extend
  username: ""
  isTyping: false

Chat.User.reopenClass
  find: (username, callback) ->
    $.get('/ajax/user/' + username).done((user) -> callback user).error(-> callback {username: username, isGuest: true})

  createUsers: (users) ->
    users.map (u) -> Chat.User.create u
