Chat.ChanRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ({chan_name}) ->
    chan = Chat.getChanByName chan_name
    if chan
      chan.set "newMessages", 0
      return chan
    Chat.join chan_name



