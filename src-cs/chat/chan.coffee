define [
  "./message"
], (Message) ->

  Em.Object.extend

    name: ""
    messages: []
    usernames: []
	
    init: ->
      @_super()
      @messages = []

    received: (message) ->
      console.debug "chan #{@name} got ", message
      switch message.type
        when "msg"
          console.debug "push", message
          @messages.pushObject Message.create message.username, message.text
        when "part"
          @usernames.removeObject message.username
        when "join"
          @usernames.pushObject message.username

    sendMessage: (text) ->
      Chat.send
        type: "msg"
        "chan-name": @name
        text: text

    part: ->
      Chat.send
        type: "part"
        "chan-name": @name
      Chat.chans.removeObject @

    open: ->
      Chat.controller.openChan @