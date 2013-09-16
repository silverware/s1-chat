Chat.ChanRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ->
    $.get '/ajax/chans'
