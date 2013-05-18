define [
  "text!/chan_template.hbs"
], (template) ->
  Ember.View.extend
    chan: null
    template: Ember.Handlebars.compile template
    classNames: ['content chan']

    didInsertElement: ->
      @$("#messageForm").submit (event) =>
        event.preventDefault()

        message = @$("#message").val()
        if message.indexOf("/") == 0
          commandArgs = message[1..message.length].split " "
          command = commandArgs[0]
          args = commandArgs[1..commandArgs.length]
          chat[command].apply chat, args
        else
          @chan.sendMessage message

        @$("#message").val ""
    
      Chat.view.arrangeContent()

