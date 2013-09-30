Chat.MessageView = Ember.View.extend
  message: null
  template: Ember.Handlebars.compile """
    {{#if view.message.isMessage}}
      <div class="message-time">{{msg.formattedDate}}</div>
      <div class='message-name'>{{msg.name}}</div>
      <div class='message-body'>{{msg.text}}</div>
    {{/if}}
    {{#if view.message.isUser}}
      {{#with view.message.user}}
      <div class="alert alert-info">
        <div>{{username}} {{#if isGuest}} [guest]{{/if}}</div>
        geolocation, abstand, foto, nick
        <span>its super</span>
        <ul>
          <li {{action queryUser view.message.user.username target="view.parentView"}}>Query</li>
        </ul>
      </div>
      {{/with}}
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
