define [
  "text!/chan_template.hbs"
  "./contentView"
], (template, ContentView) ->
  ContentView.extend
    chan: null
    template: Ember.Handlebars.compile template
    classNames: ['content chan']

    navId: (->
      @get("chan.name")
    ).property("chan")

    didInsertElement: ->
      @_super()
      @$("#messageForm").submit (event) =>
        event.preventDefault()

        message = @$("#message").val()
        if message.indexOf("/") == 0
          commandArgs = message[1..message.length].split " "
          command = commandArgs[0]
          args = commandArgs[1..commandArgs.length]
          Chat[command].apply Chat, args
        else
          @chan.sendMessage message

        @$("#message").val ""
    
    
    onMessageSizeChanged: (->
      @$(".messages").scrollTop(@$(".messages")[0].scrollHeight)
    ).observes("chan.messages.@each")

