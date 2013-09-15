Chat.QueryStreamView = Ember.View.extend
  stream: null
  template: Ember.Handlebars.compile """

    [:div.header "{{view.stream.username}}" [:i.icon-remove.close]]
    [:div.messages
    "{{#each msg in view.stream.messages}}{{msg.name}}: {{msg.text}}<br />{{/each}}"]
    [:form.queryForm
     [:input.query {:type "text" :placeholder "Message"}]
    ]
  """
  classNames: ['queryStream']

  didInsertElement: ->
    @$(".queryForm").submit (event) =>
      event.preventDefault()
      message = @$(".query").val()
      @stream.query message
      @$(".query").val ""
    @$(".close").click => @stream.hide()
