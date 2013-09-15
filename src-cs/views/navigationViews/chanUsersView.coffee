define [
  "./userItemView"
], (UserItemView) ->
  Ember.View.extend
    chan: null
    UserItemView: UserItemView

    template: Ember.Handlebars.compile """
      <ul>
        <li {{action "part" target="view.chan"}}> <i class="icon-reply"></i>Leave Channel</li>
      </ul>
      <h5>participants</h5>
      <ul>
        {{#each user in view.chan.usernames}}
         <li>{{view view.UserItemView userBinding="user" chanBinding="view.chan"}}</li>
        {{/each}}
      </ul>
    """
    classNames: ['users']

    didInsertElement: ->
      # todo


