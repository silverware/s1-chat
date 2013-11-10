Chat.ChanView = Chat.ContentView.extend
  template: Ember.Handlebars.compile """

    {{view Chat.ChanUsersView chanBinding="model"}}
    <div class="chan-title">{{name}}</div>
    <div class="messages">
      <div class="content-messages">
      <div style="overflow: auto" class="content-messages-wrapper">
      {{#each msg in messages}}
        {{view Chat.MessageView messageBinding="msg"}}
      {{/each}}
      </div>
      </div>
    </div>

    <form id="messageForm" {{action "doAction" on="submit" target="view"}}>
     <input id="message" type="text" placeholder="Message" autocomplete="off" />
    </form>
  """
  classNames: ['chan', 'content-2']
  messageHistory: []
  historyIndex: 0
  previousMessageLength: 0

  init: ->
    @_super()
    @set "messageHistory", []
    @typingTimer = null

  didInsertElement: ->
    FORWARD_SLASH = 191

    @_super()
    @adjustHeight()
    $(window).resize => @adjustHeight()
    f = () =>
      @typingTimer = null
      @get("controller.model").sendTypingStatus("stoppedtyping")

    @$("#message").keyup ({keyCode}) =>
      message = @$("#message").val()
      if (not (message.charAt(0) == '/' or message.length == 0 or @previousMessageLength == message.length))
        @previousMessageLength = message.length
        if null == @typingTimer
          @get("controller.model").sendTypingStatus("typing")
          @typingTimer = null
          @typingTimer = window.setTimeout(f, 3000)
        else
          clearTimeout @typingTimer
          @typingTimer = window.setTimeout(f, 3000)

    @$("#message").keydown ({keyCode}) =>

      if keyCode is 38 and @historyIndex >= 0
        @historyIndex--
      if keyCode is 40 and @historyIndex <= @messageHistory.length
        @historyIndex++
      if keyCode is 38 or keyCode is 40
        message = @messageHistory.objectAt @historyIndex
        if message then @$("#message").val message

  actions:
    doAction: ->
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
        @get("controller.model").sendMessage message

      @$("#message").val ""
    queryUser: (username) ->
      @$("form input").val "/query #{username} "
      @$("form input").focus()

  onMessageRendered: ->
    @$(".content-messages-wrapper").scrollTop(@$(".content-messages-wrapper")[0].scrollHeight)

  adjustHeight: ->
    if not @$() then return
    @$('.content-messages').height @$(".messages").height()
    @$('.content-messages').width @$(".messages").width()
    @$('.content-messages-wrapper').css 'max-height', @$(".messages").height() + "px"


