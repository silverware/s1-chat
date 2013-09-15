Chat.LoginController = Ember.Controller.extend
  actions:
    login: ->
      #Log the user in, then reattempt previous transition if it exists.
      previousTransition = @get 'previousTransition'
      if previousTransition
        @set 'previousTransition', null
        previousTransition.retry()
      else
        #Default back to homepage
        @transitionToRoute 'index'
