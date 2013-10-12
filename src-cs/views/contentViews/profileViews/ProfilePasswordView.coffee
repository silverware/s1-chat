Chat.ProfilePasswordView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  template: Ember.Handlebars.compile """
    {{view Chat.ProfileNavView}}
    <h1>Change Password</h1>
     <form class="form-horizontal" {{action "changePassword" target="view" on="submit"}}>
      {{view Chat.TextField viewName="password-old" type="password" label="Old Password"}}
      {{view Chat.TextField viewName="password1" type="password" label="New Password"}}
      {{view Chat.TextField viewName="password2" type="password" label="New Password (repeat)"}}
      {{view Chat.Button value="Change Password"}}
    </form>
  """
  actions:
    changePassword: ->
      $.post "/ajax/user/password", form: @$("form").serializeForm(), ticket: Chat.ticket, @handleResponse

  didInsertElement: ->
    @_super()

