Chat.ChanRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ({chan_name}) ->
    chan = Chat.getChanByName chan_name
    if chan then return chan
    Chat.join chan_name



