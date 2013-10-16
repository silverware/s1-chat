Chat.ChanUsersView = Ember.View.extend
  chan: null
  tagName: 'nav'
  classNames: ['nav-2', 'users']

  template: Ember.Handlebars.compile """
    <ul>
      <li {{action part target="view.chan"}}> <i class="icon-reply"></i>Leave Channel</li>
    </ul>
    <h5>participants</h5>
    <ul>
      {{#each user in view.chan.usernames}}
       <li {{action showUserInfo user target="view"}}><img src="/ajax/user/{{unbound user}}/image" style="height: 35px" />&nbsp;&nbsp;{{user}}</li>
      {{/each}}
    </ul>
  """

  didInsertElement: ->
    # todo

  actions:
    showUserInfo: (username) ->
      Chat.User.find username, (user) =>
        @chan.addMessage
          type: "user"
          user: user

