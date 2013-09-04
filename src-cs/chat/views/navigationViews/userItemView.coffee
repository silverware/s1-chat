define ["chat/ajaxHelper", "chat/Message"], (Ajax, Message) ->
  Ember.View.extend
    user: null
    chan: null
    template: Ember.Handlebars.compile """<img src="img/dummy.png" />&nbsp;&nbsp;{{user}}"""
    classNames: ['username']

    didInsertElement: ->
      #$(':not(.popover li)').on 'click', (e) ->
      #    $('.popover').each ->
      #      $(@).hide()

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
      Ajax.getUser @user, (user) =>
        @chan.addMessage Message.create
          type: "user"
          user: user



