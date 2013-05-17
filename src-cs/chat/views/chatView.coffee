define [
  "text!/chat_template.hbs"
  "./chanView"
  "./queryStreamView"
  "./chanUsersView"
  "./homeView"
], (template, ChanView, QueryStreamView, ChanUsersView, HomeView) ->

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
      $(".homeLink").click =>
        @openHome()
      $("#joinChat").submit (event) =>
        event.preventDefault()
        @chat.join $("#channelName").val()
        $("#channelName").val ""


    openHome: ->
      @removeNavItems()
      @updateContent HomeView.create()

    openChan: (chan) ->
      @removeNavItems()

      contentView = ChanView.create chan: chan
      usersView = ChanUsersView.create chan: chan
      
      @appendNavItem usersView
      @updateContent contentView
      
      

    removeNavItems: ->
      for i in [0...@navigation.length]
        @navigation[i].destroy()
        $(".nav-#{i + 1}").remove()
      @navigation.clear()

    appendNavItem: (view) ->
      lastIndex = @navigation.length
      $("<nav class='nav-#{lastIndex + 1}'>").insertAfter ".nav-#{lastIndex}"
      view.appendTo ".nav-#{lastIndex + 1}"
      @navigation.pushObject view
      

    updateContent: (view) ->
      $("#content").empty()
      view.appendTo "#content"
      @arrangeContent()

    arrangeContent: ->
      marginLeft = ((@navigation.length + 1) * 200)
      $("#content").css "left", "#{marginLeft}px"

      $(".nav-0 li").click ({target}) ->
        $(".nav-0 li").removeClass "active"
        $(target).addClass "active"