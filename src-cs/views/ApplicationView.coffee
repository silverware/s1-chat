Chat.ApplicationView = Em.View.extend
  classNames: ['chat']
  defaultTemplate: Ember.Handlebars.compile """
    <nav class="nav-0">
      <ul>
        {{#link-to 'index' tagName='li'}}<i class="icon-home"></i>home{{/link-to}}
      </ul>

      {{#if Chat.isAuthenticated}}
        <h5>channels</h5>
        <ul>
          {{#each chan in Chat.chans}}
            {{#link-to 'chan' chan.name tagName='li'}}<img src="img/dummy.png" />
              {{chan.name}}
              <i {{action part target="chan"}} style="float: right; padding-top: 8px" class="icon-remove"></i>
            {{/link-to}}
          {{/each}}
        </ul>

        <h5>private channels</h5>
        <ul>
          {{#each channel in Chat.privateChannels}}
            <li {{action "open" target="channel"}}><img src="img/dummy.png" /> {{channel.username}} </li>
          {{/each}}
        </ul>
      {{/if}}

      <div class="bottom-nav">
        {{#if Chat.isAuthenticated}}
          <h5>{{Chat.ticket.username}}</h5>
          <ul>
            {{#unless Chat.isGuest}}"
              {{#link-to 'profile' tagName='li'}}<i class="icon-edit"></i>edit profile{{/link-to}}
            {{/unless}}
            <li {{action logout target="Chat"}}><i class="icon-edit"></i>log out</li>
          </ul>
       {{else}}
         <ul>
           {{#link-to 'login' tagName='li'}} <i class="icon-edit"></i>log in{{/link-to}}
           <li {{action openLoginPopup "#register-pane" target="view"}}> <i class="icon-edit"></i>register</li>
         </ul>
       {{/if}}
       </div>

      </nav>
      <div id="queryStreams">
        {{#each stream in Chat.queryStreams}}
          {{#if stream.isVisible}}{{view Chat.QueryStreamView streamBinding="stream"}}{{/if}}
        {{/each}}
      </div>


      {{outlet}}
    """
