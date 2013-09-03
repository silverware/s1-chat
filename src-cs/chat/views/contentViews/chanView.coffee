define [
  "./contentView"
], (ContentView) ->
  ContentView.extend
    chan: null
    template: Ember.Handlebars.compile """
      <div class="chan-title">{{view.chan.name}}</div>
      <div class="messages">
        <div class="content-messages">
        {{#each msg in view.chan.messages}}
          <div><div class='message-key'><span>{{msg.formattedDate}}</span> {{msg.name}}</div> <div class='message-body'>{{msg.text}}</div></div>
        {{/each}}
        </div>
      </div>

      <form id="messageForm">
       <input id="message" type="text" placeholder="Message" autocomplete="off" style="width: 95%" />
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
      @$(".messages").scrollTop(@$(".messages")[0].scrollHeight)
    ).observes("chan.messages.@each")

    adjustHeight: ->
      if not @$() then return
      @$('.content-messages').height @$(".messages").height()

    queryUser: (username) ->
      @$("form input").val "/query #{username} "
      @$("form input").focus()
