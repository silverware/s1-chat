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
      
      @$("#username").focus()

      $("#guest-login-form").submit (event) =>
        event.preventDefault()
        username = $("input[name=\"username\"]").val()
        Chat.authCallback = (errorText) =>
          if Chat.get("isAuthenticated")
            @$().fadeOut("slow")
          else
            @$("<span>" +  errorText + "</span>").insertBefore("#guest-login-form")

        Chat.authenticate username, ""

    show: ->
      @_super()
     
      $(document).ready(=>
        $("#username").focus()
      )


