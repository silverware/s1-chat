Chat.ProfileView = Chat.ContentView.extend
  template: Ember.Handlebars.compile """
    <h1>Edit Profile</h1>
    <form class="form-horizontal" id="userForm">
      {{view Chat.TextFieldView valueBinding="email" viewName="email" label="Email"}}
      {{view Chat.BirthDateView}}
      {{view Chat.TextAreaView valueBinding="about" viewName="about" label="About"}}
      <button class="btn btn-primary" {{action "save"}} type="submit">Save</button>
     </form>
    <fieldset>
      <legend>Change Password</legend>
      <form class="form-horizontal" id="passwordForm">
        {{view Chat.TextFieldView viewName="password-old" type="password" label="Old Password"}}
        {{view Chat.TextFieldView viewName="password1" type="password" label="New Password"}}
        {{view Chat.TextFieldView viewName="password2" type="password" label="New Password (repeat)"}}
        <button class="btn btn-primary" {{action "changePassword" target="view"}} type="submit">Change Password</button>
       </form>
    </fieldset>
  """




  didInsertElement: ->
    @_super()

    # todo

