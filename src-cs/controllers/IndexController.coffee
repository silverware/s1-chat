Chat.IndexController = Ember.ArrayController.extend
  actions:
    join: (chanName) ->
      #todo

  createAnonChan: ->
    $.post "/chan/create", ({chanName}) ->
      Chat.join chanName
