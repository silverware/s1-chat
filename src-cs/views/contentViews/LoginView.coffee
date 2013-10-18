Chat.LoginView = Chat.ContentView.extend Chat.ValidationMixin,
  template: Ember.Handlebars.compile """
    <button {{action testLogin target="view"}} type="button">login as Test</button>
    <div class="login-box">
    <h1>Login</h1>
    <ul id="login-tabs" class="nav nav-tabs">
     <li class="active"> <a href="#guest-login-pane" data-toggle="tab">Guest</a></li>
     <li> <a href="#login-pane" data-toggle="tab">Login</a></li>
     <li> <a href="#register-pane" data-toggle="tab">Register</a></li>
    </ul>
    <div class="tab-content">
     <div class="tab-pane active" id="guest-login-pane">
     <form class="form-horizontal" id="guest-login-form">
        {{view Chat.TextField label="Username" placeholder="Guest" viewName="guest-username"}}
        <button type="submit">Submit</button>
     </form>
     </div>

     <div class="tab-pane" id="login-pane">
     <form class="form-horizontal" id="login-form">
      {{view Chat.TextField label="Username" viewName="login-username"}}
      {{view Chat.TextField label="Password" viewName="login-password" type="password"}}
      <button type="submit">Submit</button>
     </form>
      </div>

     <div class="tab-pane" id="register-pane">
     <form class="form-horizontal" id="register-form">
      {{view Chat.TextField label="E-Mail" viewName="email"}}
      {{view Chat.TextField label="Username" viewName="username"}}
      {{view Chat.TextField label="Password" viewName="password1" type="password"}}
      {{view Chat.TextField label="Password (repeat)" viewName="password2" type="password"}}
      <button type="submit">Submit</button>
     </form>
      </div>

    </div>

  """
  didInsertElement: ->
    @_super()

    @$("a[href=" + @initialTab + "]").tab('show')

    @$("#guest-username").focus()

    @$("#guest-login-form").submit (event) =>
      event.preventDefault()
      @disableButtons @$("#guest-login-form"), true
      username = $("input[name=\"guest-username\"]").val()

      Chat.authCallback = (errorText) =>
        @disableButtons @$("#guest-login-form"), false
        if Chat.get("isAuthenticated")
          @get("controller").send 'login'
        else
          @handleResponse errorText

      Chat.authenticateAsGuest username

    @$("#login-form").submit (event) =>
      event.preventDefault()
      @disableButtons @$("#login-form"), true

      username = @$("[name=login-username]").val()
      password = @$("[name=login-password]").val()

      Chat.authCallback = (validationResult) =>
        @disableButtons @$("#login-form"), false
        if Chat.get("isAuthenticated")
          @get("controller").send 'login'
        else
          @handleResponse validationResult

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
    @$("[name=login-username]").val("test")
    @$("[name=login-password]").val("test")
    @$("#login-form").submit()


