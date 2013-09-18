Chat.MessageView = Ember.View.extend
  message: null
  template: Ember.Handlebars.compile """
    {{#if view.message.isMessage}}
      <div class="message-time">{{msg.formattedDate}}</div>
      <div class='message-name'>{{msg.name}}</div>
      <div class='message-body'>{{msg.text}}</div>
    {{/if}}
    {{#if view.message.isUser}}
      <div class="alert alert-info">
        <div>{{view.message.user.username}}</div>
        Bayern BAYERN BAYERN
        <span>its super</span>
      </div>
    {{/if}}
    {{#if view.message.isPart}}
      <div class="alert alert-info">
        <div>{{view.message.name}} left this channel</div>
      </div>
    {{/if}}
    {{#if view.message.isJoin}}
      <div class="alert alert-info">
        <div>{{view.message.name}} joined this channel</div>
      </div>
    {{/if}}
    {{#if view.message.isInfo}}
      <div class="alert alert-info">{{view.message.text}}</div>
    {{/if}}
  """
  classNames: ['message']

  didInsertElement: ->
    @_super()
