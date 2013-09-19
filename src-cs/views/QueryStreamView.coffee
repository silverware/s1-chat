Chat.QueryStreamView = Ember.View.extend
  stream: null
  template: Ember.Handlebars.compile """

    <div class="header">{{view.stream.username}} <i class="icon-remove close" {{action hide target="view.stream"}}></i></div>
    <div class="messages">
      {{#each msg in view.stream.messages}}
        {{msg.name}}: {{msg.text}}<br />{{/each}}
    </div>
    <form class="queryForm">
     <input class="query" type="text" placeholder="Message" />
    </form>
  """
  classNames: ['queryStream']

  didInsertElement: ->
    @$(".queryForm").submit (event) =>
      event.preventDefault()
      message = @$(".query").val()
      @stream.query message
      @$(".query").val ""

