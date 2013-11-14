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
      {{#each user in users}}
       <li {{action showUserInfo user.name}}>
        <img src="/ajax/user/{{unbound user.name}}/image" style="height: 35px" />
        &nbsp;&nbsp;{{user.name}}
        {{#if user.isTyping}}
        <i style="float: right; padding-top: 12px" title="is typing"
          class="icon-reply"></i>
        {{/if}}
      </li>
      {{/each}}
    </ul>
  """

  didInsertElement: ->
    # todo
