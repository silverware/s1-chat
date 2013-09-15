Chat.ContentView = Ember.View.extend
  classNames: ['content']

  didInsertElement: ->
    @arrangeContent()


  arrangeContent: ->
    marginLeft = 220
    @$().css "left", "#{marginLeft}px"
