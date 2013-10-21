Chat.ProfileIndexRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ->
    $.get "/ajax/user/" + Chat.ticket.username

Chat.ProfilePasswordRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin
Chat.ProfilePhotoRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin


