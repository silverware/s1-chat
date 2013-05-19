define [
  "text!/home_template.hbs"
  "./contentView"
], (template, ContentView) ->
  ContentView.extend
    template: Ember.Handlebars.compile template
    classNames: ['content home']

    didInsertElement: ->
      @_super()
    

