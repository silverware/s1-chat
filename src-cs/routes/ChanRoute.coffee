Chat.ChanRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ->
    Ember.$.getJSON('/ajax/chans').then (chans) -> chans
