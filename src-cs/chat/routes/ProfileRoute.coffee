Chat.ProfileRoute = Ember.Route.extend
  model: ->
    Ember.$.getJSON('/pulls').then (data) ->
      data
