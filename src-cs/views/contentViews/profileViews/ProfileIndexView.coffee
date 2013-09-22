Chat.ProfileIndexView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  template: Ember.Handlebars.compile """

    {{view Chat.ProfileNavView}}
    <h1>Edit Profile</h1>
    <form class="form-horizontal" id="userForm">
      {{view Chat.TextFieldView valueBinding="email" viewName="email" label="Email"}}
      {{view Chat.BirthDateView}}
      {{view Chat.TextAreaView valueBinding="about" viewName="about" label="About"}}
      <button {{action save target="view"}} type="submit">Save</button>
     </form>


    TODO: PHOto upload: webcam
  """
  actions:
    save: ->
      $.post "/ajax/user/", {user: @get('controller.model') , "session-id": Chat.ticket["session-id"]}, (result) =>
        @handleResponse result

  didInsertElement: ->
    @_super()

    # todo

