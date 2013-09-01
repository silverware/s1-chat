define [
  "text!/query_stream_template.hbs"
], (template) ->
  Ember.View.extend
    stream: null
    template: Ember.Handlebars.compile template
    classNames: ['queryStream']

    didInsertElement: ->
      @$(".queryForm").submit (event) =>
        event.preventDefault()
        message = @$(".query").val()
        @stream.query message
        @$(".query").val ""
      @$(".close").click => @stream.hide()
