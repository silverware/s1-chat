define [
  "text!/chat_template.hbs"
  "./chanView"
  "./queryStreamView"
  "./userItemView"
], (template, ChanView, QueryStreamView, UserItemView) ->

  Handlebars.registerHelper "keyvalue", (obj, fn) ->
    (fn.fn(key: key, value: value) for own key, value of Ember.getPath(@, obj)).join('')

  Ember.View.extend
    chat: null
    ChanView: ChanView
    QueryStreamView: QueryStreamView
    UserItemView: UserItemView
    template: Ember.Handlebars.compile template
    classNames: ['chat']

    didInsertElement: ->
      console.debug "huhu"
      $("#joinChat").submit (event) =>
        event.preventDefault()
        @chat.join $("#channelName").val()
        $("#channelName").val ""
      $(document).keyup (e) ->
        if e.keyCode is 27 then $("#control-center").slideUp "medium"
      $(".navbar").click (event) =>
        $("#control-center").slideDown "medium"
