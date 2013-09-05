define [], () ->
  Ember.View.extend
    message: null
    template: Ember.Handlebars.compile """
      {{#if view.message.isMessage}}
        <div class='message-key'><span>{{msg.formattedDate}}</span> {{msg.name}}</div> <div class='message-body'>{{msg.text}}</div>
      {{/if}}
      {{#if view.message.isUser}}
        <div class="user-message">
          <h5>{{view.message.user.username}}</h5>
          He is gay
          <span>its super</span>
        </div>
      {{/if}}
      {{#if view.message.isPart}}
        <div class="part-message">
          <h5>{{view.message.name}} left this channel</h5>
        </div>
      {{/if}}
      {{#if view.message.isJoin}}
        <div class="part-message">
          <h5>{{view.message.name}} joined this channel</h5>
        </div>
      {{/if}}
    """
    classNames: ['message']

    didInsertElement: ->
      @_super()
