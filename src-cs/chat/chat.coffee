define [
  "./chan"
  "./message"
  "./views/chatView"
  "./names"
  "./queryStream"
  "./videoChatController"
], (Chan, Message, ChatView, names, QueryStream, VideoChat) ->

  Em.Application.extend

    websocket: null
    chans: []
    initialChan: "Test"
    username: ""

    # Private Chats
    queryStreams: []
    ticket:
      username: null
      "session-id": null
    maxId: 0
    sentObjects: {}

    videoChatController: VideoChat
	
    init: ->
      @_super()
      @set "queryStreams", []
      @set "chans", []
      @websocket = $.gracefulWebSocket "ws://#{window.location.hostname}:8008/"
      @view = ChatView.create chat: @
      @websocket.onmessage = @onResponse.bind @
      randomName = names[Math.floor(Math.random() * names.length)]

      @authenticate randomName, "pass"
      @set "username", randomName

      #setTimeout((=> @join(@initialChan)), 1100) if @initialChan
        
    authenticate: (username, password) ->
      @ticket.username = username
      authentification =
        type: "auth"
        username: username
        password: password
      setTimeout((=> @send(authentification, true)), 1000)

    join: (channelName) ->
      @send
        type: "join"
        "chan-name": channelName

    query: (receivers, text...) ->
      receivers = receivers.split ","
      text = text.join " "
      @send
        type: "query"
        receivers: receivers
        text: text
      @createQueryStream receiver, text for receiver in receivers
    
    video: (receiver) ->
       @videoChatController.startVideo true, receiver
      
    send: (obj, noTicket) ->
      @set "maxId", @maxId + 1
      obj.id = @get "maxId"
      obj.ticket = @ticket if not noTicket
      @sentObjects[obj.id] = obj
      console.debug "send message with object", obj
      @websocket.send JSON.stringify(obj)

    onResponse: (event) ->
      console.debug "received data", event.data
      response = JSON.parse event.data
      switch response.type
        when "authsuccess"
          @ticket["session-id"] = response["session-id"]
        when "joinsuccess"
          obj = @sentObjects[response.id]
          chan = Chan.create(id: @maxId, name: obj["chan-name"], usernames: response.usernames)
          @chans.pushObject chan
          @view.openChan chan
        when "query"
          @createQueryStream response.username, response.text, true
        when "video"
          @videoChatController.init response
        else
          chan.received response for chan in @chans when chan.name is response["chan-name"]
            

    createQueryStream: (user, text, received) ->
      author = if received then user else @ticket.username
      if (@queryStreams.every (x) -> user isnt x.username)
        @queryStreams.pushObject QueryStream.create(username: user)
      stream.messages.pushObject Message.create(author, text) for stream in @queryStreams when stream.username is user

