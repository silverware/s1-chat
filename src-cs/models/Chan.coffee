Chat.Chan = Em.Object.extend

  name: ""
  messages: []
  usernames: []
  isAnonymous: false
  newMessages: 0

  init: ->
    @_super()
    @messages = []
    if @isAnonymous
      @addMessage
        type: "info"
        text: "You can invite your buddies digga. http://#{window.location.hostname}/chan/join/#{@name}"

  received: (message) ->
    console.debug "chan #{@name} got ", message
    switch message.type
      when "msg"
        @addMessage name: message.username, text: message.text
        @onMessageReceived()
      when "part"
        @usernames.removeObject message.username
        @addMessage type: "part", name: message.username
      when "join"
        @usernames.pushObject message.username
        @addMessage type: "join", name: message.username

  sendMessage: (text) ->
    Chat.sendMsg
      type: "msg"
      "chan-name": @name
      text: text

  part: ->
    Chat.Router.router.transitionTo 'index'
    Chat.sendMsg
      type: "part"
      "chan-name": @name
    Chat.chans.removeObject @

  addMessage: (message) ->
    @messages.pushObject Chat.Message.create message

  onMessageReceived: ->
    if not false #Chat.Router.router
      @set "newMessages", @newMessages + 1
