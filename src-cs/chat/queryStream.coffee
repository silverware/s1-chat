define ->
  Em.Object.extend

    username: ""
    messages: []
	
    init: ->
      @_super()
      @messages = []

    query: (message) ->
      chat.query @username, message

    close: ->
      chat.queryStreams.removeObject @