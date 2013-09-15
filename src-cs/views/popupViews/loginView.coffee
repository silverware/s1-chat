Chat.LoginView = PopupView.extend
  template: Ember.Handlebars.compile template
  classNames: ['login']

  insertFieldErrorMessages: (fieldErrors) ->
    for err in fieldErrors
      @insertErrorMessage(err[0], err[1])

  insertErrorMessage: (field, message) ->
    controlGroup = @$('#' + field).parent().parent()
    controlGroup.addClass 'error'
    @$('<span class="help-inline">' + message + '</span>').insertAfter @$('#'+ field)

  clearErrorMessages: (formID) ->
    @$(formID + " .control-group .help-inline").remove()
    @$(formID + " .error").removeClass("error")

  didInsertElement: ->
    @_super()

    @$("a[href=" + @initialTab + "]").tab('show')

    @$("#guest-username").focus()

    @$("#guest-login-form").submit (event) =>
      event.preventDefault()
      username = $("input[name=\"guest-username\"]").val()
      controlGroup = $("#guest-username").parent().parent()

      @clearErrorMessages("#guest-login-form")

      buttonHTML = @$(":button").html()
      @$(":button").html("&nbsp;<i class=\"icon-spinner icon-spin\"></i>")

      Chat.authCallback = (errorText) =>

        # remove spinner
        @$(":button").html(buttonHTML)

        if Chat.get("isAuthenticated")
          @destroy()
        else
          @insertFieldErrorMessages(errorText.fieldErrors)

      Chat.authenticateAsGuest username

    @$("#login-form").submit (event) =>
      event.preventDefault()
      @clearErrorMessages("#login-form")

      username = @$("#login-username").val()
      password = @$("#login-password").val()

      Chat.authCallback = (validationResult) =>
        if Chat.get("isAuthenticated")
          @destroy()
        else
          @insertFieldErrorMessages(validationResult.fieldErrors)

      Chat.authenticate username, password

    @$("#register-form").submit (event) =>
      event.preventDefault()
      @clearErrorMessages("#register-form")
      formData = @$("#register-form").serialize()

      buttonHTML = @$(":button").html()
      @$(":button").html("&nbsp;<i class=\"icon-spinner icon-spin\"></i>")

      $.post('/register', formData, (data) =>
        @$(":button").html(buttonHTML)
        if data.fieldErrors
          @insertFieldErrorMessages(data.fieldErrors)
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
    $(document).ready =>
      $("#guest-username").focus()

  testLogin: ->
    @$("#login-username").val("test")
    @$("#login-password").val("test")
    @$("#login-form").submit()


