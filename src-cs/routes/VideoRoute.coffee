Chat.VideoRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ({username}) ->
    videoChat = Chat.getVideoChat username



