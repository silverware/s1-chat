Chat.Chan = Em.Object.extend

  name: ""
  messages: []
  users: []
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
        @users.removeObject @getUser message.username
        @addMessage type: "part", name: message.username
      when "join"
        @users.pushObject Chat.User.create message.user
        @addMessage type: "join", name: message.username
      when "typing"
        @getUser(message.username).set "isTyping", true
      when "stoppedtyping"
        @getUser(message.username).set "isTyping", false

  sendTypingStatus: (status) ->
    Chat.sendMsg
      type: status
      "chan-name": @name

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
    if Chat.Router.router.currentParams.chan_name isnt @name
      @set "newMessages", @newMessages + 1

  getUser: (username) ->
    (@users.filter (u) -> u.name is username)[0]

  clear: ->
    @messages.clear()
