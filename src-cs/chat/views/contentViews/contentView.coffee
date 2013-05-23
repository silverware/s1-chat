define ->
  Ember.View.extend
    classNames: ['content']

    didInsertElement: ->
      Chat.controller.arrangeContent()
    

