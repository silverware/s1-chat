Chat.ProfileNavView = Ember.View.extend
  tagName: 'nav'
  classNames: ['nav-2']

  template: Ember.Handlebars.compile """
    <div class="bottom-nav">
          <ul>
            {{#unless Chat.isGuest}}
              {{#link-to 'profile' tagName='li'}}<i class="icon-edit"></i>edit profile{{/link-to}}
            {{/unless}}
            <li {{action logout target="Chat"}}><i class="icon-edit"></i>upload photo</li>
            <li {{action logout target="Chat"}}><i class="icon-edit"></i>change password</li>
          </ul>
  """

  didInsertElement: ->
    # todo

  part: ->
    @chan.part()


