window.Chat = Em.Application.extends

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

  videoChatController: VideoChat

  init: ->
    @_super()
    @set "queryStreams", []
    @set "chans", []
    @websocket = $.gracefulWebSocket "ws://#{window.location.hostname}:8008/"
    @websocket.onmessage = @onResponse.bind @
    $(window).unload => @onUnload()
    @loadStorageData()
    console.debug @initialChan

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
    Chat.controller.openHome()

  getChanByName: (chanName) ->
    for chan in @chans
      if chan.name is chanName
        return chan

  join: (chanName) ->
    chan = @getChanByName chanName
    if chan
      @controller.openChan chan
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
        chan = Chan.create
          id: @maxId
          name: obj["chan-name"]
          usernames: response.usernames
          isAnonymous: response.anonymous
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
            toastr.error(response.text)
      else
        chan.received response for chan in @chans when chan.name is response["chan-name"]


  createQueryStream: (user, text, received) ->
    author = if received then user else @ticket.username
    if (@queryStreams.every (x) -> user isnt x.username)
      @queryStreams.pushObject QueryStream.create username: user
    stream.messages.pushObject Message.create(name: author, text: text) for stream in @queryStreams when stream.username is user

  isAuthenticated: (->
    @get("ticket.session-id") isnt null
  ).property("ticket.session-id", "ticket.username")

  privateChannels: (->
    @get("queryStreams")
  ).property("queryStreams.@each")

  onUnload: ->
    localStorage.username = @get "ticket.username"
    localStorage.isGuest = @get "isGuest"
    localStorage.password = @get "ticket.passwordHash"

  loadStorageData: ->
    if not (localStorage and localStorage.username) then return
    setTimeout (=> @authenticate localStorage.username, null, true), 1000


Chat.ApplicationController = Ember.Controller.extend
  navigationViews: []
  contentView: null
  view: null

  init: ->
    @_super()
    @view = ChatView.create()
    @openHome()

  openHome: ->
    @removeNavItems()
    @setContentView HomeView.create()

  openChan: (chan) ->
    if not Chat.get("isAuthenticated") then return LoginView.create()
    @removeNavItems()

    contentView = ChanView.create chan: chan
    usersView = ChanUsersView.create chan: chan

    @appendNavItem usersView
    @setContentView contentView

  openEditProfile: ->
    @removeNavItems()
    @setContentView ProfileEditView.create()

  removeNavItems: ->
    for i in [0...@navigationViews.length]
      @navigationViews[i].destroy()
      $(".nav-#{i + 1}").remove()
    @navigationViews.clear()

  appendNavItem: (view) ->
    lastIndex = @navigationViews.length
    $("body").append "<nav class='nav-#{lastIndex + 1}'>"
    view.appendTo ".nav-#{lastIndex + 1}"
    @navigationViews.pushObject view

  setContentView: (view) ->
    @contentView?.destroy()
    view.appendTo "body"
    @set "contentView", view
    navId = view.get "navId"
    $(".nav-0 li").removeClass "active"
    setTimeout (-> $(".nav-0 li[nav-id='#{navId}']").addClass "active"), 10


  arrangeContent: ->
    marginLeft = ((@navigationViews.length + 1) * 220)
    $(".content").css "left", "#{marginLeft}px"







if typeof webkitRTCPeerConnection != "undefined"
    RTCPeerConnection = webkitRTCPeerConnection
else if typeof mozRTCPeerConnection != "undefined"
    RTCPeerConnection = mozRTCPeerConnection

define [
  "./views/contentViews/videoChatView"
  ], (VideoChatView) ->
  VideoChatController =

    # RTCPeerConnection
    peerConnection: null

    init: (data) ->
      if not @peerConnection
        @startVideo false, data.username
      if data.payload.sdp
        @peerConnection.setRemoteDescription(new RTCSessionDescription(data.payload.sdp))
      else if data.payload.candidate
        @peerConnection.addIceCandidate(new RTCIceCandidate(data.payload.candidate))

    startVideo: (isCaller, receiver) ->

      Chat.controller.removeNavItems()
      Chat.controller.setContentView VideoChatView.create()

      pc_config = "iceServers": ["url": "stun:stun.l.google.com:19302"]
      @peerConnection = new RTCPeerConnection(pc_config)
      @peerConnection.onicecandidate = (evt) =>
        Chat.sendMsg
          type: "video"
          receiver: receiver
          payload:
            candidate: evt.candidate

      @peerConnection.onaddstream = (evt) ->
        console.log("stream added", evt)
        $("#remoteview").attr("src", URL.createObjectURL(evt.stream))
        $("#remoteview").get(0).play()

      navigator.webkitGetUserMedia {audio: true, video: true}, (stream) =>
        $("#selfview").attr "src", URL.createObjectURL(stream)
        $("#selfview").get(0).play()
        @peerConnection.addStream stream

        if isCaller
          console.debug("I am caller.")
          @peerConnection.createOffer (desc) =>
              @peerConnection.setLocalDescription desc
              Chat.sendMsg
                  type: "video"
                  receiver: receiver
                  payload:
                    sdp: desc
        else
          console.debug("I am callee.")
          @peerConnection.createAnswer (desc) =>
            @peerConnection.setLocalDescription desc
            Chat.sendMsg
                type: "video"
                receiver: receiver
                payload:
                  sdp: desc


Chat.ValidationMixin = Ember.Mixin.create
  insertFieldErrorMessages: (fieldErrors) ->
    for err in fieldErrors
      @insertErrorMessage err[0], err[1]

  insertErrorMessage: (field, message) ->
    field = @get field
    field.set "status", "error"
    field.set "message", message

  clearErrorMessages: (formID) ->
    return "TODO"
    @$(" .control-group .help-inline").remove()
    @$(" .error").removeClass("error")

  showSuccessMessage: ->

  handleResponse: (result) ->
    if result.fieldErrors
      @insertFieldErrorMessages result.fieldErrors
    else
      @clearErrorMessages()
      @showSuccessMessage()




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


Chat.Message = Em.Object.extend
  type: "message"
  name: ""
  text: ""
  date: null

  init: ->
    @set "date", new Date()

  formattedDate: (->
    moment(@get("date")).format "HH:mm"
  ).property("date")

  isMessage: (->
     @get("type") is "message"
  ).property("type")

  isUser: (->
    @get("type") is "user"
  ).property("type")

  isPart: (->
    @get("type") is "part"
  ).property("type")

  isJoin: (->
    @get("type") is "join"
  ).property("type")

  isInfo: (->
    @get("type") is "info"
  ).property("type")



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


Chat.User = Em.Object.extend
  username: ""

Chat.User.reopenClass
  find: (id) ->
    Ember.$.get


Chat.LoginRoute = Ember.Route.extend
  model: ->
    Ember.$.getJSON('/pulls').then (data) ->
      data


Chat.ProfileRoute = Ember.Route.extend
  model: ->
    Ember.$.getJSON('/pulls').then (data) ->
      data


Chat.Router.map ->
  @resource 'chan', path: '/:chan_name'
  @route 'about'
  @route 'login'


Chat.ApplicationView = Em.View.extend
  classNames: ['chat']
  template: Ember.Handlebars.compile """
    <nav class="nav-0">
      <ul>
        <li nav-id="home"> <i class="icon-home></i>home</li>
      </ul>

      {{#if Chat.isAuthenticated}}
        <h5>channels</h5>
        <ul>
          {{#each chan in Chat.chans}}
            <li {{action "open" target="chan"}} nav-id="{{unbound chan.name}}"><img src="img/dummy.png" />
              {{chan.name}} <i {{action part target="chan"}} style="float: right; padding-top: 8px" class="icon-remove"></i>
            </li>
          {{/each}}
        </ul>

        <h5>private channels</h5>
        <ul>
          {{#each channel in Chat.privateChannels}}
            <li {{action "open" target="channel"}}><img src="img/dummy.png" /> {{channel.username}} </li>
          {{/each}}
        </ul>
      {{/if}}

      <div class="bottom-nav>
        {{#if Chat.isAuthenticated}}
          <h5>{{Chat.ticket.username}}</h5>
          <ul>
            {{#unless Chat.isGuest}}"
              <li nav-id="editProfile" {{action openEditProfile target="Chat.controller"}}> <i class="icon-edit"></i>edit profile</li>
            {{/unless}}
            <li {{action logout target="Chat"}}> [:i.icon-edit] log out </li>
          </ul>
       {{else}}
         <ul>
           <li {{action openLoginPopup "#guest-login-pane" target="view"}}> <i class="icon-edit"></i>log in</li>
           <li {{action openLoginPopup "#register-pane" target="view"}}> <i class="icon-edit"></i>register</li>
         </ul>
       {{/if}}
       </div>

      </nav>
      <div id="queryStreams">
        {{#each stream in Chat.queryStreams}}
          {{#if stream.isVisible}}{{view view.QueryStreamView streamBinding="stream"}}{{/if}}
        {{/each}}
      </div>
    """


Chat.MessageView = Ember.View.extend
    message: null
    template: Ember.Handlebars.compile """
      {{#if view.message.isMessage}}
        <div class="message-time">{{msg.formattedDate}}</div>
        <div class='message-name'>{{msg.name}}</div>
        <div class='message-body'>{{msg.text}}</div>
      {{/if}}
      {{#if view.message.isUser}}
        <div class="alert alert-info">
          <div>{{view.message.user.username}}</div>
          He is gay
          <span>its super</span>
        </div>
      {{/if}}
      {{#if view.message.isPart}}
        <div class="alert alert-info">
          <div>{{view.message.name}} left this channel</div>
        </div>
      {{/if}}
      {{#if view.message.isJoin}}
        <div class="alert alert-info">
          <div>{{view.message.name}} joined this channel</div>
        </div>
      {{/if}}
      {{#if view.message.isInfo}}
        <div class="alert alert-info">{{view.message.text}}</div>
      {{/if}}
    """
    classNames: ['message']

    didInsertElement: ->
      @_super()


Chat.QueryStreamView = Ember.View.extend
  stream: null
  template: Ember.Handlebars.compile """

    [:div.header "{{view.stream.username}}" [:i.icon-remove.close]]
    [:div.messages
    "{{#each msg in view.stream.messages}}{{msg.name}}: {{msg.text}}<br />{{/each}}"]
    [:form.queryForm
     [:input.query {:type "text" :placeholder "Message"}]
    ]
  """
  classNames: ['queryStream']

  didInsertElement: ->
    @$(".queryForm").submit (event) =>
      event.preventDefault()
      message = @$(".query").val()
      @stream.query message
      @$(".query").val ""
    @$(".close").click => @stream.hide()


Chat.ChanView = ContentView.extend
  chan: null
  template: Ember.Handlebars.compile """
    <div class="chan-title">{{view.chan.name}}</div>
    <div class="messages">
      <div class="content-messages">
      <div style="overflow: auto" class="content-messages-wrapper">
      {{#each msg in view.chan.messages}}
        {{view Chat.MessageView messageBinding="msg"}}
      {{/each}}
      </div>
      </div>
    </div>

    <form id="messageForm">
     <input id="message" type="text" placeholder="Message" autocomplete="off" />
    </form>
  """
  classNames: ['content chan']
  messageHistory: []
  historyIndex: 0

  init: ->
    @_super()
    @set "messageHistory", []

  navId: (->
    @get("chan.name")
  ).property("chan")

  didInsertElement: ->
    @_super()
    @adjustHeight()
    $(window).resize => @adjustHeight()

    @$("#messageForm").submit (event) =>
      event.preventDefault()
      message = @$("#message").val()
      if not message then return
      @messageHistory.pushObject message
      @historyIndex = @messageHistory.length

      if message.indexOf("/") is 0
        commandArgs = message[1..message.length].split " "
        command = commandArgs[0]
        args = commandArgs[1..commandArgs.length]
        Chat[command].apply Chat, args
      else
        @chan.sendMessage message

      @$("#message").val ""

    @$("#message").keydown ({keyCode}) =>
      if keyCode is 38 and @historyIndex >= 0
        @historyIndex--
      if keyCode is 40 and @historyIndex <= @messageHistory.length
        @historyIndex++
      if keyCode is 38 or keyCode is 40
        message = @messageHistory.objectAt @historyIndex
        if message then @$("#message").val message


  onMessageSizeChanged: (->
    @$(".content-messages-wrapper").scrollTop(@$(".content-messages-wrapper")[0].scrollHeight)
  ).observes("chan.messages.@each")

  adjustHeight: ->
    if not @$() then return
    @$('.content-messages').height @$(".messages").height()
    @$('.content-messages').width @$(".messages").width()
    @$('.content-messages-wrapper').css 'max-height', @$(".messages").height() + "px"

  queryUser: (username) ->
    @$("form input").val "/query #{username} "
    @$("form input").focus()


Chat.ContentView = Ember.View.extend
  classNames: ['content']

  didInsertElement: ->
    Chat.controller.arrangeContent()




Chat.HomeView = ContentView.extend
  template: Ember.Handlebars.compile """
    <section class="anonym">
      <button class="btn btn-large btn-primary" type="button" {{action createAnonChan target="view"}}><i class="icon-tasks"></i>create anonymous channel</button>
    </section>
  <section class="public">
    {{#each chan in view.publicChans}}
      <div class="join-chan" {{action join chan.name target="Chat"}}>{{chan.name}} ({{chan.users}})</div>
    {{/each}}
  </section>

  """
  classNames: ['content home']
  navId: "home"
  publicChans: []

  init: ->
    @_super()
    $.get "/ajax/chans", (chans) =>
      @set "publicChans", chans

  didInsertElement: ->
    @_super()

  createAnonChan: ->
    $.post "/chan/create", ({chanName}) ->
      Chat.join chanName



Chat.FormFieldView = Ember.View.extend
  classNames: ['control-group']
  classNameBindings: ['status']
  notSurrounded: false

  layout: Ember.Handlebars.compile """
    <label class="control-label" for="{{unbound view.formField.id}}">{{view.label}}</label>
      <div class="controls">
        {{yield}}
        <span class="help-inline">{{view.message}}</span>
      </div>
  """

  init: ->
    @_super()
    if @notSurrounded
      @classNames.removeObject "control-group"
      @set "layout", Ember.Handlebars.compile "{{yield}}"



Chat.BirthDateView = Chat.FormFieldView.extend
  type: "text"
  date: new Date()
  days: [1..31].map (d) -> {day: d}
  months = ["January", "February", "March", "April", "June", "July", "August", "September", "November", "December"].map (m, i) -> Em.Object.create(id: i, label: m)
  label: "Birthdate"

  template: Ember.Handlebars.compile """
    {{view Em.Select notSurrounded="true" valueBinding="view.day"
      optionValuePath="content.day" optionLabelPath="content.day" contentBinding="view.days"}}
    {{view Em.Select notSurrounded="true" valueBinding="view.month"
      optionValuePath="content.id" optionLabelPath="content.label" contentBinding="view.months"}}
    {{view Em.TextField valueBinding="view.year"}}
  """

  init: ->
    @_super()


Em.TextArea.reopen
  attributeBindings: ['maxlength', "name"]

Chat.TextAreaView = Chat.FormFieldView.extend
  template: Ember.Handlebars.compile """
    {{view Em.TextArea valueBinding="view.value"
    viewName="formField" nameBinding="view.viewName"}}
  """


Em.TextField.reopen
  attributeBindings: ['placeholder', 'disabled', 'maxlength', "name", "type"]

Chat.TextFieldView = Chat.FormFieldView.extend
  type: "text"

  template: Ember.Handlebars.compile """
    {{view Em.TextField valueBinding="view.value" placeholderBinding="view.placeholder"
    viewName="formField" nameBinding="view.viewName"
    disabledBinding="view.disabled" typeBinding="view.type"}}
  """


Chat.ProfileEditView = Chat.ContentView.extend Chat.ValidationMixin,
  template: Ember.Handlebars.compile """
    <h1>Edit Profile</h1>
    <form class="form-horizontal" id="userForm">
      {{view Chat.TextFieldView valueBinding="view.user.email" viewName="email" label="Email"}}
      {{view Chat.BirthDateView}}
      {{view Chat.TextAreaView valueBinding="view.user.about" viewName="about" label="About"}}
      <button class="btn btn-primary" {{action "save" target="view"}} type="submit">Save</button>
     </form>
    <fieldset>
      <legend>Change Password</legend>
      <form class="form-horizontal" id="passwordForm">
        {{view Chat.TextFieldView viewName="password-old" type="password" label="Old Password"}}
        {{view Chat.TextFieldView viewName="password1" type="password" label="New Password"}}
        {{view Chat.TextFieldView viewName="password2" type="password" label="New Password (repeat)"}}
        <button class="btn btn-primary" {{action "changePassword" target="view"}} type="submit">Change Password</button>
       </form>
    </fieldset>
  """
  navId: "editProfile"
  user: {}

  init: ->
    @_super()
    $.get "/ajax/user/" + Chat.ticket.username, (result) =>
      @set "user", result

  save: ->
    $.post "/ajax/user/", {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
      @handleResponse result

  changePassword: ->
    $.post "/ajax/user/" + Chat.ticket.username + "/password", {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
      @handleResponse result


  didInsertElement: ->
    @_super()

    # todo



define [
  "./contentView"
], (ContentView) ->
  ContentView.extend
    template: Ember.Handlebars.compile """ 
      <video width='300' id='remoteview'></video>
      <video width='100 'id='selfview'></video>
    """



Em.Select.reopen
  attributeBindings: ["name"]

Chat.SelectFieldView = FormField.extend
  template: Ember.Handlebars.compile """
    {{view Em.Select contentBinding="view.content"
        optionValuePathBinding="view.optionValue"
        optionLabelPathBinding="view.optionLabel"
        valueBinding="view.value"
    viewName="formField" nameBinding="view.viewName"}}
  """

  didInsertElement: ->
    @_super()




define [
  "./userItemView"
], (UserItemView) ->
  Ember.View.extend
    chan: null
    UserItemView: UserItemView

    template: Ember.Handlebars.compile """
      <ul>
        <li {{action "part" target="view.chan"}}> <i class="icon-reply"></i>Leave Channel</li>
      </ul>
      <h5>participants</h5>
      <ul>
        {{#each user in view.chan.usernames}}
         <li>{{view view.UserItemView userBinding="user" chanBinding="view.chan"}}</li>
        {{/each}}
      </ul>
    """
    classNames: ['users']

    didInsertElement: ->
      # todo




Chat.UserItemView = Ember.View.extend
  user: null
  chan: null
  template: Ember.Handlebars.compile """<img src="img/dummy.png" />&nbsp;&nbsp;{{user}}"""
  classNames: ['username']

  didInsertElement: ->
    @$().popover
      placement: "right"
      trigger: "click"
      title: @user
      html: true
      content: """
        <ul>
          <li onclick="Chat.controller.contentView.queryUser('#{@user}');"><i class="queryUser icon-edit"></i>private message</li>
          <li><i class="icon-edit"></i>private chat</li>
        </ul>
        <script></script>
      """

  click: ->
    Chat.User.find @user, (user) =>
      @chan.addMessage Message.create
        type: "user"
        user: user





define [
  "text!/login_template.hbs"
  "./popupView"
  "form/Save"
], (template, PopupView, Save) ->
  PopupView.extend
    template: Ember.Handlebars.compile template
    classNames: ['login']

    insertFieldErrorMessages: (fieldErrors) ->
      for err in fieldErrors
        @insertErrorMessage(err[0], err[1])

    insertErrorMessage: (field, message) ->
      controlGroup = @$('#' + field).parent().parent()
      controlGroup.addClass 'error'
      @$('<span class="help-inline">' + message + '</span>').insertAfter @$('#'+ field)

    clearErrorMessages: (formID) ->
      @$(formID + " .control-group .help-inline").remove()
      @$(formID + " .error").removeClass("error")

    didInsertElement: ->
      @_super()

      @$("a[href=" + @initialTab + "]").tab('show')

      @$("#guest-username").focus()

      @$("#guest-login-form").submit (event) =>
        event.preventDefault()
        username = $("input[name=\"guest-username\"]").val()
        controlGroup = $("#guest-username").parent().parent()

        @clearErrorMessages("#guest-login-form")

        buttonHTML = @$(":button").html()
        @$(":button").html("&nbsp;<i class=\"icon-spinner icon-spin\"></i>")

        Chat.authCallback = (errorText) =>

          # remove spinner
          @$(":button").html(buttonHTML)

          if Chat.get("isAuthenticated")
            @destroy()
          else
            @insertFieldErrorMessages(errorText.fieldErrors)

        Chat.authenticateAsGuest username

      @$("#login-form").submit (event) =>
        event.preventDefault()
        @clearErrorMessages("#login-form")

        username = @$("#login-username").val()
        password = @$("#login-password").val()

        Chat.authCallback = (validationResult) =>
          if Chat.get("isAuthenticated")
            @destroy()
          else
            @insertFieldErrorMessages(validationResult.fieldErrors)

        Chat.authenticate username, password

      @$("#register-form").submit (event) =>
        event.preventDefault()
        @clearErrorMessages("#register-form")
        formData = @$("#register-form").serialize()

        buttonHTML = @$(":button").html()
        @$(":button").html("&nbsp;<i class=\"icon-spinner icon-spin\"></i>")

        $.post('/register', formData, (data) =>
          @$(":button").html(buttonHTML)
          if data.fieldErrors
            @insertFieldErrorMessages(data.fieldErrors)
          else if data.errors
            html = "<ul>"
            for err in data.errors
              html += "<li>" + err  + "</li>"
            html += "</ul>"
            @$(html).insertBefore("#register-form")
          else
            @$("a[href=#login-pane]").tab('show')
            @$("#login-username").val(@$("#username").val())
            @$('<div class="alert alert-success fade in"><button type="button" class="close" data-dismiss="alert">×</button>Super gemacht, Arschloch!</div>').insertBefore("#login-tabs")
        , "json")

    show: ->
      @_super()
      $(document).ready =>
        $("#guest-username").focus()

    testLogin: ->
      @$("#login-username").val("test")
      @$("#login-password").val("test")
      @$("#login-form").submit()




define ->

  Ember.View.extend
    classNames: ['popup-container']
    layout: Ember.Handlebars.compile """
      <div class="popup-content">{{yield}}</div>
    """

    didInsertElement: ->
      $(document).keyup (e) =>
        if e.keyCode is 27
          @hide()

      popupContent = @$(".popup-content")

      popupContent.css("position","absolute")
      #popupContent.css("top", Math.max(0, (($(window).height() - popupContent.outerHeight()) / 2) + $(window).scrollTop()) + "px")
      #popupContent.css("left", Math.max(0, (($(window).width() - popupContent.outerWidth()) / 2) + $(window).scrollLeft()) + "px")

      $(".popup-content").fadeIn()

    show: ->
      @appendTo "body"
      #console.debug @$()
      #@$(".popup-container").fadeIn "slow"

    hide: ->
      $(".popup-container").fadeOut("fast", () =>
        @destroy())



