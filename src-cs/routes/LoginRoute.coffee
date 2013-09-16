Chat.LoginRoute = Ember.Route.extend
  model: ->
    $.get('/pulls').then (data) ->
      data
