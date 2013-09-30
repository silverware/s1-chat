Chat.User = Em.Object.extend
  username: ""

Chat.User.reopenClass
  find: (username, callback) ->
    $.get('/ajax/user/' + username).done((user) -> callback user).error(-> callback {username: username, isGuest: true})
