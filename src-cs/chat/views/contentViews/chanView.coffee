define [
  "text!/chan_template.hbs"
  "./contentView"
], (template, ContentView) ->
  ContentView.extend
    chan: null
    template: Ember.Handlebars.compile template
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
      @$("#messageForm").submit (event) =>
        event.preventDefault()

        message = @$("#message").val()
        @messageHistory.pushObject message
        @historyIndex = @messageHistory.length

        if message.indexOf("/") == 0
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


    queryUser: (username) ->
      @$("form input").val "/query #{username} "
      @$("form input").focus()