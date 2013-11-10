Chat.ChanUsersView = Ember.View.extend
  chan: null
  tagName: 'nav'
  classNames: ['nav-2', 'users']

  template: Ember.Handlebars.compile """
    <ul>
      <li {{action part}}> <i class="icon-reply"></i>Leave Channel</li>
    </ul>
    <h5>participants</h5>
    <ul>
      {{#each user in usernames}}
       <li {{action showUserInfo user}}><img src="/ajax/user/{{unbound user}}/image" style="height: 35px" />&nbsp;&nbsp;{{user}}</li>
      {{/each}}
    </ul>
  """

  didInsertElement: ->
    # todo
