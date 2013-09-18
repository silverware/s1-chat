Chat.EnsureAuthentificationMixin =
  beforeModel: (transition) ->
    if not Chat.get 'isAuthenticated'
      loginController = Chat.controllerFor 'login'
      loginController.set 'previousTransition', transition
      @transitionTo 'login'
