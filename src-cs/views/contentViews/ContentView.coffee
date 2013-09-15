Chat.ContentView = Ember.View.extend
  classNames: ['content']

  didInsertElement: ->
    Chat.controller.arrangeContent()


