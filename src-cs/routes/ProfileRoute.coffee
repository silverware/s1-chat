Chat.ProfileRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  renderTemplate: ->
    @render 'profileNav',
      outlet: 'sidebar'



Chat.ProfileIndexRoute = Chat.ProfileRoute.extend
  model: ->
    $.get "/ajax/user/" + Chat.ticket.username
  renderTemplate: ->
    @_super()
    @render 'profileIndex'

Chat.ProfilePasswordRoute = Chat.ProfileRoute.extend
  renderTemplate: ->
    @_super()
    @render 'profilePassword'


Chat.ProfilePhotoRoute = Chat.ProfileRoute.extend
  renderTemplate: ->
    @_super()
    @render 'profilePhoto'



