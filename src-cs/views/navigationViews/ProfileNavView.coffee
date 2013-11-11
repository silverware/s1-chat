Chat.ProfileNavView = Ember.View.extend
  tagName: 'nav'
  classNames: ['nav-2']

  template: Ember.Handlebars.compile """
    <h5>Options</h5>
    <ul>
      {{#link-to 'profile.index' tagName='li'}}<i class="icon-edit"></i>general information{{/link-to}}
      {{#link-to 'profile.password' tagName='li'}}<i class="icon-lock"></i>change password{{/link-to}}
      {{#link-to 'profile.photo' tagName='li'}}<i class="icon-picture"></i>upload photo{{/link-to}}
    </ul>
  """

  didInsertElement: ->
    # todo


