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
      <div class="user-profile-view">

          <div class="actions">
           <h5>Options</h5>
            <ul>
              <li {{action queryUser view.message.user.username target="view.parentView"}}><i class="icon-comments"></i>Query</li>
              <li {{action video view.message.user.username target="Chat"}}><i class="icon-comments"></i>video</li>
            </ul>
          </div>
          <h5>{{username}} {{#if isGuest}} [guest]{{/if}} </h5>
          <section>
            <img src="/ajax/user/{{unbound username}}/image" />
            geolocation, abstand
            <span>{{about}}</span>
          </section>


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
    @get("parentView").onMessageRendered()
