Chat.ProfileIndexView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  template: Ember.Handlebars.compile """
    {{view Chat.ProfileNavView}}
    <h1>Edit Profile</h1>
    <form class="form-horizontal" {{action save target="view" on="submit"}}>
      {{view Chat.TextField valueBinding="email" viewName="email" label="Email"}}
      {{view Chat.BirthDate}}
      {{view Chat.TextAreaView valueBinding="about" viewName="about" label="About"}}
      {{view Chat.Button value="Save"}}
     </form>
  """
  actions:
    save: ->
      $.post "/ajax/user/", {user: @get('controller.model') , "session-id": Chat.ticket["session-id"]}, (result) =>
        @handleResponse result

  didInsertElement: ->
    @_super()
