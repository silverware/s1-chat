Chat.ChanRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ({chan_name}) ->
    Chat.getChanByName chan_name
