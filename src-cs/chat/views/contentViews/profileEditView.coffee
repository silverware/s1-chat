define [
  "./contentView"
  "form/validationMixin"
  "form/textField"
], (ContentView, Validation) ->
  ContentView.extend Validation,
    template: Ember.Handlebars.compile """
      <h1>Edit Profile</h1>
      <form class="form-horizontal" id="userForm">
        {{view TextField valueBinding="view.user.email" viewName="email" label="Email"}}
        <button class="btn btn-primary" {{action "save" target="view"}} type="submit">Save</button>
       </form>
      <fieldset>
        <legend>Change Password</legend>
        <form class="form-horizontal" id="passwordForm">
          {{view TextField viewName="password-old" label="Old Password"}}
          {{view TextField viewName="password1" label="New Password"}}
          {{view TextField viewName="password2" label="New Password (repeat)"}}
          <button class="btn btn-primary" {{action "changePassword" target="view"}} type="submit">Change Password</button>
         </form>
      </fieldset>
    """
    navId: "editProfile"
    user: {}

    init: ->
      @_super()
      $.get "/ajax/user/" + Chat.ticket.username, (result) =>
        @set "user", result

    save: ->
      $.post "/ajax/user/" + Chat.ticket.username, {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
        @handleResponse result

    changePassword: ->
      $.post "/ajax/user/" + Chat.ticket.username + "/password", {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
        @handleResponse result


    didInsertElement: ->
      @_super()

      # todo

