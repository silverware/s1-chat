define [
  "text!/home_template.hbs"
], (template) ->
  Ember.View.extend
    template: Ember.Handlebars.compile template
    classNames: ['home']

    didInsertElement: ->
      # todo
    

