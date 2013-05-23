define [
  "text!/chan_template.hbs"
  "./contentView"
], (template, ContentView) ->
  ContentView.extend
    chan: null
    template: Ember.Handlebars.compile template
    classNames: ['content chan']
    messageHistory: []


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

        if message.indexOf("/") == 0
          commandArgs = message[1..message.length].split " "
          command = commandArgs[0]
          args = commandArgs[1..commandArgs.length]
          Chat[command].apply Chat, args
        else
          @chan.sendMessage message

        @$("#message").val ""
    
      $("#message").keydown ({target}) ->
        #console.debug "huhu"
    
    onMessageSizeChanged: (->
      @$(".messages").scrollTop(@$(".messages")[0].scrollHeight)
    ).observes("chan.messages.@each")


    queryUser: (username) ->
      @$("form input").val "/query #{username} "
      @$("form input").focus()