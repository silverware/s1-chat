Chat.QueryStream = Em.Object.extend

  username: ""
  messages: []
  isVisible: true

  init: ->
    @_super()
    @messages = []

  query: (message) ->
    Chat.query @username, message

  hide: ->
    @set "isVisible", false

  open: ->
    @set "isVisible", true

  close: ->
    Chat.queryStreams.removeObject @
