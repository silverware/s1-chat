define [
  "text!/login_template.hbs"
  "./popupView"
  "form/Save"
], (template, PopupView, Save) ->
  PopupView.extend
    template: Ember.Handlebars.compile template
    classNames: ['login']

    insertErrorMessage: (field, message) ->
      formID = '#register-form'
      controlGroup = @$(formID + ' #' + field).parent().parent()
      controlGroup.addClass 'error'
      @$('<span class="help-inline">' + message + '</span>').insertAfter @$(formID + ' #'+ field)

    clearErrorMessages: ->
      formID = '#register-form'
      @$(formID + " .control-group .help-inline").remove()
      @$(formID + " .error").removeClass("error")

    didInsertElement: ->
      @_super()

      @$("a[href=" + @initialTab + "]").tab('show')
      
      @$("#guest-username").focus()

      $("#guest-login-form").submit (event) =>
        event.preventDefault()
        username = $("input[name=\"guest-username\"]").val()
        controlGroup = $("#guest-username").parent().parent()

        # clear old error messages
        controlGroup.removeClass("#guest-login-form error")
        @$("#guest-login-form .help-inline").remove()

        buttonHTML = @$(":button").html()
        @$(":button").html("&nbsp;<i class=\"icon-spinner icon-spin\"></i>")
        
        Chat.authCallback = (errorText) =>

          # remove spinner
          @$(":button").html(buttonHTML)

          if Chat.get("isAuthenticated")
            @$().fadeOut("slow")
          else
            controlGroup.addClass("error")
            @$("<span class=\"help-inline\">" +  errorText + "</span>").insertAfter("#guest-username")

        Chat.authenticate username, ""

      $("#login-form").submit (event) =>
        event.preventDefault

      $("#register-form").submit (event) =>
        event.preventDefault()
        @clearErrorMessages()
        formData = @$("#register-form").serialize()

        buttonHTML = @$(":button").html()
        @$(":button").html("&nbsp;<i class=\"icon-spinner icon-spin\"></i>")

        $.post('/register', formData, (data) =>
          @$(":button").html(buttonHTML)
          if data.fieldErrors
            for entry in data.fieldErrors
              @insertErrorMessage(entry[0], entry[1])

          else if data.errors
            html = "<ul>"
            for err in data.errors
              html += "<li>" + err  + "</li>"
            html += "</ul>"
            @$(html).insertBefore("#register-form")
          else
            @$("a[href=#login-pane]").tab('show')
            @$("#login-username").val(@$("#username").val())
            @$('<div class="alert alert-success fade in"><button type="button" class="close" data-dismiss="alert">×</button>Super gemacht, Arschloch!</div>').insertBefore("#login-tabs")
        , "json")

    show: ->
      @_super()
     
      $(document).ready(=>
        $("#guest-username").focus()
      )


