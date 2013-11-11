Chat.ProfileNavView = Ember.View.extend
  tagName: 'nav'
  classNames: ['nav-2']

  template: Ember.Handlebars.compile """
    <h5>Options</h5>
    <ul>
      {{#link-to 'profile.index' tagName='li'}}<i class="icon-edit"></i>General Information{{/link-to}}
      {{#link-to 'profile.password' tagName='li'}}<i class="icon-lock"></i>Change Password{{/link-to}}
      {{#link-to 'profile.photo' tagName='li'}}<i class="icon-picture"></i>Upload Photo{{/link-to}}
    </ul>
  """

  didInsertElement: ->
    # todo


