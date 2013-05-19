define [
  "text!/login_template.hbs"
  "./popupView"
  "form/Save"
], (template, PopupView, Save) ->
  PopupView.extend
    template: Ember.Handlebars.compile template
    classNames: ['login']

    didInsertElement: ->
      @_super()
      new Save
      	form: @$("form")

