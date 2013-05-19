define [
  "text!/login_template.hbs"
  "./popupView"
], (template, PopupView) ->
  PopupView.extend
    template: Ember.Handlebars.compile template
    classNames: ['login']

    didInsertElement: ->
      @_super()
      @$("form").submit (event) ->
      	event.preventDefault()

