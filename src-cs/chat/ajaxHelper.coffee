define ->
  exports =
    getUser: (username, callback) ->
      $.get "/ajax/user/" + username, (result) ->
        callback result
