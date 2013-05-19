define ->
  Ember.View.extend
    classNames: ['content']

    didInsertElement: ->
      Chat.view.arrangeContent()
    

