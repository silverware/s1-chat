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
        controlGroup = $("#username").parent().parent()

        # clear old error messages
        controlGroup.removeClass("error")
        $(".help-inline").remove()

        buttonHTML = @$(":button").html()
        @$(":button").html("&nbsp;<i class=\"icon-spinner icon-spin\"></i>")
        
        Chat.authCallback = (errorText) =>

          # remove spinner
          @$(":button").html(buttonHTML)

          if Chat.get("isAuthenticated")
            @$().fadeOut("slow")
          else
            controlGroup.addClass("error")
            @$("<span class=\"help-inline\">" +  errorText + "</span>").insertAfter("#username")

        Chat.authenticate username, ""

    show: ->
      @_super()
     
      $(document).ready(=>
        $("#username").focus()
      )


