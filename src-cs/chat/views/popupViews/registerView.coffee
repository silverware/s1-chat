define [
  "text!/register_template.hbs",
  "./popupView"
  "./loginView"
], (template, PopupView, LoginView) ->
  PopupView.extend
    template: Ember.Handlebars.compile template
    classNames: ['register']

    didInsertElement: ->
      @_super()

