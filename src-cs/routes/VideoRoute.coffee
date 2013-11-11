Chat.VideoRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ({username}) ->
    videoChat = Chat.getVideoChat username

  setupController: (controller, videoChat) ->
    @_super controller, videoChat
    controller.set "title", "Video Chat"

  renderTemplate: ->
    @render 'videoChat'
