Chat.ChanUsersView = Ember.View.extend
  chan: null
  tagName: 'nav'

  template: Ember.Handlebars.compile """
    <ul>
      <li {{action "part" target="view"}}> <i class="icon-reply"></i>Leave Channel</li>
    </ul>
    <h5>participants</h5>
    <ul>
      {{#each user in view.chan.usernames}}
       <li>{{view Chat.UserItemView userBinding="user" chanBinding="view.chan"}}</li>
      {{/each}}
    </ul>
  """
  classNames: ['users']

  didInsertElement: ->
    # todo

  part: ->
    @chan.part()


