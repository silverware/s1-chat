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

  init: ->
    @_super()
    @set "messageHistory", []

  didInsertElement: ->
    @_super()
    @adjustHeight()
    $(window).resize => @adjustHeight()
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




  onMessageSizeChanged: (->
    console.debug "lsdfkj"
    @$(".content-messages-wrapper").scrollTop(@$(".content-messages-wrapper")[0].scrollHeight)
  ).observes("messages.@each")

  adjustHeight: ->
    if not @$() then return
    @$('.content-messages').height @$(".messages").height()
    @$('.content-messages').width @$(".messages").width()
    @$('.content-messages-wrapper').css 'max-height', @$(".messages").height() + "px"

  queryUser: (username) ->
    @$("form input").val "/query #{username} "
    @$("form input").focus()
