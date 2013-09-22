Chat.ProfilePasswordView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  template: Ember.Handlebars.compile """
    {{view Chat.ProfileNavView}}
    <h1>Change Password</h1>
     <form class="form-horizontal" id="passwordForm">
      {{view Chat.TextFieldView viewName="password-old" type="password" label="Old Password"}}
      {{view Chat.TextFieldView viewName="password1" type="password" label="New Password"}}
      {{view Chat.TextFieldView viewName="password2" type="password" label="New Password (repeat)"}}
      <button {{action "changePassword" target="view"}} type="submit">Change Password</button>
    </form>

    TODO: PHOto upload: webcam
  """
  actions:
    changePassword: ->
      $.post "/ajax/user/" + Chat.ticket.username + "/password", {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
        @handleResponse result

  didInsertElement: ->
    @_super()

    # todo

