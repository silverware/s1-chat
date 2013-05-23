define ->
  Ember.View.extend
    user: null
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
      
      

