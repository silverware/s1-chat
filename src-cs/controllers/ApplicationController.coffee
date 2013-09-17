Chat.ApplicationController = Ember.Controller.extend

  init: ->
    @_super()

  logout: ->
    Chat.logout()

