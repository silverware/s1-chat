Chat.User = Em.Object.extend
  username: ""

Chat.User.reopenClass
  find: (id, callback) ->
    $.get('/ajax/user/' + id).then (user) -> callback user
