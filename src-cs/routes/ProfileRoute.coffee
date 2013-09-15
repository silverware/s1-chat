Chat.ProfileRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ->
    Ember.$.getJSON('/pulls').then (data) ->
      data
