Chat.QueryStream = Em.Object.extend

  username: ""
  messages: []
  isVisible: true
  newMessages: 0

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

  onMessagesChanged: (->
    if not @isVisible
      @set "newMessages", @newMessages + 1
  ).observes("messages.@each")

  onVisibilityChanged: (->
    if @isVisible
      @set "newMessages", 0
  ).observes("isVisible")
