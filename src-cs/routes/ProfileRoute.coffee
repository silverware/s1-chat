Chat.ProfileIndexRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ->
    $.get "/ajax/user/" + Chat.ticket.username
