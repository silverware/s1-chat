Chat.IndexRoute = Ember.Route.extend
  model: ->
    Ember.$.getJSON('/ajax/chans').then (chans) -> chans


