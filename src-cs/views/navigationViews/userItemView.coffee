Chat.UserItemView = Ember.View.extend
  user: null
  chan: null
  template: Ember.Handlebars.compile """<img src="img/dummy.png" />&nbsp;&nbsp;{{user}}"""
  classNames: ['username']


  didInsertElement: ->
    @$().popover
      placement: "right"
      trigger: "click"
      title: @user
      html: true
      content: """
        <ul>
          <li onclick="Chat.controller.contentView.queryUser('#{@user}');"><i class="queryUser icon-edit"></i>private message</li>
          <li><i class="icon-edit"></i>private chat</li>
        </ul>
        <script></script>
      """

  click: ->
    Chat.User.find @user, (user) =>
      @chan.addMessage Message.create
        type: "user"
        user: user



