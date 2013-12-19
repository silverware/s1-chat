Chat.VideoRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ({username}) ->
    Chat.getVideoChat username

  setupController: (controller, videoChat) ->
    @_super controller, videoChat
    controller.set "title", "Video Chat"

  renderTemplate: ->
    @render 'video'
