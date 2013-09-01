define [
  "./chan"
  "./message"
  "./controllers/chatController"
  "./queryStream"
  "./videoChatController"
], (Chan, Message, ChatController, QueryStream, VideoChat) ->

  Em.Application.extend

    websocket: null
    chans: []
    controller: {}
    initialChan: "Test"

    # Private Chats
    queryStreams: []

    # authentication
    authCallback: null
    ticket:
      username: null
      "session-id": null
    authMessageID: null

    maxId: 0
    sentObjects: {}

    videoChatController: VideoChat

    init: ->
      @_super()
      @set "queryStreams", []
      @set "chans", []
      @websocket = $.gracefulWebSocket "ws://#{window.location.hostname}:8008/"
      @websocket.onmessage = @onResponse.bind @
      @set "controller", ChatController.create()

    authenticate: (username, password, asGuest = false) ->
      @set "ticket.username", username
      authentification =
        type: "auth"
        username: username
        password: password
        "as-guest": asGuest
      @sendMsg authentification, true

    authenticateAsGuest: (username) ->
      @authenticate username, null, true

    logout: ->
      if not @get("isAuthenticated") then return
      @sendMsg
        type: "logout"
      @set "ticket.username", null
      @set "ticket.session-id", null
      @chans.clear()
      @queryStreams.clear()
      Chat.controller.openHome()

    join: (channelName) ->
      @sendMsg
        type: "join"
        "chan-name": channelName

    query: (receivers, text...) ->
      receivers = receivers.split ","
      text = text.join " "
      @sendMsg
        type: "query"
        receivers: receivers
        text: text
      @createQueryStream receiver, text for receiver in receivers

    video: (receiver) ->
      @videoChatController.startVideo true, receiver

    sendMsg: (obj, noTicket) ->
      @set "maxId", @maxId + 1
      obj.id = @get "maxId"
      obj.ticket = @ticket if not noTicket
      @sentObjects[obj.id] = obj
      console.debug "sent message with object", obj
      @websocket.send JSON.stringify(obj)

    onResponse: (event) ->
      console.debug "received data", event.data
      response = JSON.parse event.data
      switch response.type
        when "authsuccess"
          @set "ticket.session-id", response["session-id"]
          @authCallback()
        when "joinsuccess"
          obj = @sentObjects[response.id]
          chan = Chan.create(id: @maxId, name: obj["chan-name"], usernames: response.usernames)
          @chans.pushObject chan
          @controller.openChan chan
        when "query"
          @createQueryStream response.username, response.text, true
        when "video"
          @videoChatController.init response
        when "error"
            if @sentObjects[response.id].type == "auth"
              @authCallback(response.text)
        else
          chan.received response for chan in @chans when chan.name is response["chan-name"]


    createQueryStream: (user, text, received) ->
      author = if received then user else @ticket.username
      if (@queryStreams.every (x) -> user isnt x.username)
        @queryStreams.pushObject QueryStream.create username: user
      stream.messages.pushObject Message.create(author, text) for stream in @queryStreams when stream.username is user

    isAuthenticated: (->
      @get("ticket.session-id") isnt null
    ).property("ticket.session-id", "ticket.username")

    privateChannels: (->
      @get("queryStreams")
    ).property("queryStreams.@each")
