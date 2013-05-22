define [
  "text!/home_template.hbs"
  "./contentView"
], (template, ContentView) ->
  ContentView.extend
    template: Ember.Handlebars.compile template
    classNames: ['content home']
    navId: "home"

    init: ->
      @_super()

    didInsertElement: ->
      @_super()
      @$(".join-chan").click ({target}) ->
      	chanName = $(target).html()
      	Chat.join chanName

    

