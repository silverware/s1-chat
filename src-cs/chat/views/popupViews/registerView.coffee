define [
  "text!/register_template.hbs",
  "./popupView"
], (template, PopupView) ->
  PopupView.extend
    template: Ember.Handlebars.compile template
    classNames: ['register']

    didInsertElement: ->
      @_super()
      
   
 
