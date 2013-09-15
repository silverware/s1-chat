Chat.EnsureAuthentificationMixin =
  beforeModel: (transition) ->
    if not Chat.get 'isAuthenticated'
      loginController = @controllerFor 'login'
      loginController.set 'previousTransition', transition
      @transitionTo 'login'
