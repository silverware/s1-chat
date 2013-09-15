Chat.Chan = Em.Object.extend

  name: ""
  messages: []
  usernames: []
  isAnonymous: false

  init: ->
    @_super()
    @messages = []
    if @isAnonymous
      @addMessage Message.create
        type: "info"
        text: "You can invite your buddies digga. http://#{window.location.hostname}/chan/join/#{@name}"

  received: (message) ->
    console.debug "chan #{@name} got ", message
    switch message.type
      when "msg"
        console.debug "push", message
        @addMessage Message.create name: message.username, text: message.text
      when "part"
        @usernames.removeObject message.username
        @addMessage Message.create type: "part", name: message.username
      when "join"
        @usernames.pushObject message.username
        @addMessage Message.create type: "join", name: message.username

  sendMessage: (text) ->
    Chat.sendMsg
      type: "msg"
      "chan-name": @name
      text: text

  part: ->
    Chat.controller.openHome()
    Chat.sendMsg
      type: "part"
      "chan-name": @name
    Chat.chans.removeObject @

  open: ->
    Chat.controller.openChan @

  addMessage: (message) ->
    @messages.pushObject message
