define ->
  Em.Object.extend

    username: ""
    messages: []
	
    init: ->
      @_super()
      @messages = []

    query: (message) ->
      Chat.query @username, message

    close: ->
      Chat.queryStreams.removeObject @