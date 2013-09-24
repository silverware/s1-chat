Chat.ProfilePhotoView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  template: Ember.Handlebars.compile """
    {{view Chat.ProfileNavView}}
    <h1>Upload Photo</h1>
    <ul id="login-tabs" class="nav nav-tabs">
     <li class="active p33"> <a href="#webcam-pane" data-toggle="tab">Webcamera</a></li>
     <li class="p33"><a href="#login-pane" data-toggle="tab">Upload</a></li>
     <li class="p33"><a href="#register-pane" data-toggle="tab">Gravatar</a></li>
    </ul>
    <div class="tab-content">
     <div class="tab-pane active" id="webcam-pane">
        <div id="photobooth" style="width: 400px; height: 400px"></div>
        <div id="preview"></div>
        <button >TAKE PICTURE</button>
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
      <button type="submit" style="width: 95%; bottom: 20px; position: absolute;">Save Changes</button>

  """
  actions:
    save: ->
      $.post "/ajax/user/", {user: @get('controller.model') , "session-id": Chat.ticket["session-id"]}, (result) =>
        @handleResponse result

  changePassword: ->
    $.post "/ajax/user/" + Chat.ticket.username + "/password", {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
      @handleResponse result

  didInsertElement: ->
    @_super()
    $('#photobooth').photobooth().on "image", (event, dataUrl) ->
      $("#preview").append "<img src='#{dataUrl}' />"

