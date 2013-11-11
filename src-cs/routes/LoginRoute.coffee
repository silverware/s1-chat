Chat.LoginRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set "initialTab", "login"

Chat.SignupRoute = Ember.Route.extend
  renderTemplate: ->
    @render 'login'

  setupController: ->
    @controllerFor('login').set "initialTab", "register"
