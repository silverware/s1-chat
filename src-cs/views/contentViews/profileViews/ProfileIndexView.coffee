Chat.ProfileIndexView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  template: Ember.Handlebars.compile """
    {{view Chat.ProfileNavView}}
    <h1>Edit Profile</h1>
    <form class="form-horizontal" action="/ajax/user/">
      {{view Chat.TextField valueBinding="email" viewName="email" label="Email"}}
      {{view Chat.BirthDate valueBinding="birthdate"}}
      {{view Chat.TextAreaView valueBinding="about" viewName="about" label="About"}}
      {{view Chat.Button value="Save"}}
     </form>
  """

  didInsertElement: ->
    @_super()
