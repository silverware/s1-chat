App = Em.Application.extend

  LOG_TRANSITIONS: true

  websocket: null
  chans: []
  initialChan: ""

  # Private Chats
  queryStreams: []

  # authentication
  authCallback: null
  isGuest: null
  ticket:
    username: null
    "session-id": null
  authMessageID: null

  maxId: 0
  sentObjects: {}

  init: ->
    @_super()
    @set "queryStreams", []
    @set "chans", []
    @websocket = $.gracefulWebSocket "ws://#{window.location.hostname}:8008/"
    @websocket.onmessage = @onResponse.bind @
    $(window).unload => @onUnload()
    @loadStorageData()
    console.debug @initialChan

    return
    toastr.options =
      positionClass: "toast-bottom-right"
      closeButton: true
      newestOnTop: false

  authenticate: (username, password, isGuest = false) ->
    @set "ticket.username", username
    @set "isGuest", isGuest
    authentification =
      type: "auth"
      username: username
      password: password
      "guest?": isGuest
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


  getChanByName: (chanName) ->
    for chan in @chans
      if chan.name is chanName
        return chan

  join: (chanName) ->
    chan = @getChanByName chanName
    if chan
      #@controller.openChan chan
      return

    @sendMsg
      type: "join"
      "chan-name": chanName

  query: (receivers, text...) ->
    receivers = receivers.split ","
    text = text.join " "
    @sendMsg
      type: "query"
      receivers: receivers
      text: text

    if @ticket.username in receivers
      return
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
        if @initialChan then @join @initialChan
      when "joinsuccess"
        obj = @sentObjects[response.id]
        chan = @Chan.create
          id: @maxId
          name: obj["chan-name"]
          usernames: response.usernames
          isAnonymous: response.anonymous
        @chans.pushObject chan
        @get("Router.router").transitionTo 'profile'
      when "query"
        @createQueryStream response.username, response.text, true
      when "video"
        @videoChatController.init response
      when "error"
          if @sentObjects[response.id].type is "auth"
            @authCallback response.text
          else
            toastr.error response.text
      else
        chan.received response for chan in @chans when chan.name is response["chan-name"]


  createQueryStream: (user, text, received) ->
    author = if received then user else @ticket.username
    if (@queryStreams.every (x) -> user isnt x.username)
      @queryStreams.pushObject @QueryStream.create username: user
    stream.messages.pushObject @Message.create(name: author, text: text) for stream in @queryStreams when stream.username is user

  isAuthenticated: (->
    @get("ticket.session-id") isnt null
  ).property("ticket.session-id", "ticket.username")

  privateChannels: (->
    @get("queryStreams")
  ).property("queryStreams.@each")

  authCallback: ->

  onUnload: ->
    localStorage.username = @get "ticket.username"
    localStorage.isGuest = @get "isGuest"
    localStorage.password = @get "ticket.passwordHash"

  loadStorageData: ->
    if not (localStorage and localStorage.username) then return
    setTimeout (=> @authenticate localStorage.username, null, true), 1000

window.Chat = App.create()
