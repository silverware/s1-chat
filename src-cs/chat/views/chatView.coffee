define [
  "text!/chat_template.hbs"
  "./chanView"
  "./queryStreamView"
  "./chanUsersView"
], (template, ChanView, QueryStreamView, ChanUsersView) ->

  Ember.View.extend
    chat: null
    ChanView: ChanView
    QueryStreamView: QueryStreamView
    ChanUsersView: ChanUsersView
    template: Ember.Handlebars.compile template
    classNames: ['chat']
    navigation: []

    init: ->
      @_super()
      @navigation = []

    didInsertElement: ->
      $("#joinChat").submit (event) =>
        event.preventDefault()
        @chat.join $("#channelName").val()
        $("#channelName").val ""

    openChan: (chan) ->
      @removeNavItems()

      contentView = ChanView.create chan: chan
      usersView = ChanUsersView.create chan: chan
      
      @appendNavItem usersView

      $("#content").empty()
      contentView.appendTo "#content"
      

    removeNavItems: ->
      for i in [0...@navigation.length]
        @navigation[i].destroy()
        $(".nav-#{i + 1}").remove()
      @navigation.clear()
      @arrangeContent()

    appendNavItem: (view) ->
      lastIndex = @navigation.length
      $("<nav class='nav-#{lastIndex + 1}'>").insertAfter ".nav-#{lastIndex}"
      view.appendTo ".nav-#{lastIndex + 1}"
      @navigation.pushObject view
      @arrangeContent()

    arrangeContent: ->
      marginLeft = ((@navigation.length + 1) * 200)
      console.debug marginLeft
      $("#content").css "left", "#{marginLeft}px"