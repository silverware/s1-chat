Chat.LoginView = Chat.PopupView.extend
  template: Ember.Handlebars.compile """
    <button {{action testLogin target="view"}} type="button">login as Test</button>
    <ul id="login-tabs" class="nav nav-tabs">
     <li class="active"> [:a {:href "#guest-login-pane" :data-toggle "tab"} "Guest"]]
     <li> <a href="#login-pane" data-toggle="tab">"Login"</a></li>
     <li> <a href="#register-pane" data-toggle="tab">"Register"</a></li>
    </ul>
    <div class="tab-content">
     <div class="tab-pane active" id="guest-login-pane">
      (common/horizontal-form-to [:post "/login" {:id "guest-login-form"}]
                                 (common/bootstrap-text-field :guest-username "Username" {:placeholder "Guest"})
                                 (common/bootstrap-submit "Submit"))]

     [:div {:class "tab-pane" :id "login-pane"}
      (common/horizontal-form-to [:post "/login" {:id "login-form"}]
                                 (common/bootstrap-text-field :login-username "Username" {:placeholder ""})
                                 (common/bootstrap-password-field :login-password "Password")
                                 (common/bootstrap-submit "Submit"))]

     [:div {:class "tab-pane" :id "register-pane"}
      (common/horizontal-form-to [:post "" {:id "register-form"}]
                                 (common/bootstrap-text-field :email "E-Mail" {:placeholder "name@example.com"})
                                 (common/bootstrap-text-field :username "Username")
                                 (common/bootstrap-password-field :password1 "Password")
                                 (common/bootstrap-password-field :password2 "Password (repeat)")
                                 (common/bootstrap-submit "Submit"))
      </div>

  """
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


