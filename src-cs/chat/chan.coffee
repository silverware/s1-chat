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
          @messages.pushObject Message.create message.username, message.text
        when "part"
          @usernames.removeObject message.username
        when "join"
          @usernames.pushObject message.username

    sendMessage: (text) ->
      chat.send
        type: "msg"
        "chan-name": @name
        text: text

    part: ->
      chat.send
        type: "part"
        "chan-name": @name
      chat.chans.removeObject @

    open: ->
      console.debug "huhu"