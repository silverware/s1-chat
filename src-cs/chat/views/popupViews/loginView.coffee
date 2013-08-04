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
      view = this
      $("#guest-login-form").submit (event) ->
        event.preventDefault()
        username = $("input[name=\"username\"]").val()
        Chat.authCallback = (errorText) =>
          if Chat.get("isAuthenticated")
            view.$().fadeOut("slow")
          else
            alert errorText

        Chat.authenticate username, ""
