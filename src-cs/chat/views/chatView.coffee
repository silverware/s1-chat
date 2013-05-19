define [
  "text!/chat_template.hbs"
  "./contentViews/chanView"
  "./queryStreamView"
  "./navigationViews/chanUsersView"
  "./contentViews/homeView"
  "./popupViews/loginView"
], (template, ChanView, QueryStreamView, ChanUsersView, HomeView, LoginView) ->

  Ember.View.extend
    ChanView: ChanView
    QueryStreamView: QueryStreamView
    ChanUsersView: ChanUsersView
    template: Ember.Handlebars.compile template
    classNames: ['chat']
    navigation: []
    contentView: null

    init: ->
      @_super()
      @navigation = []

    didInsertElement: ->
      $(".homeLink").click =>
        @openHome()
      $(".loginLink").click ->
        LoginView.create().show()
      $("#joinChat").submit (event) =>
        event.preventDefault()
        Chat.join $("#channelName").val()
        $("#channelName").val ""


    openHome: ->
      @removeNavItems()
      @setContentView HomeView.create()

    openChan: (chan) ->
      @removeNavItems()

      contentView = ChanView.create chan: chan
      usersView = ChanUsersView.create chan: chan
      
      @appendNavItem usersView
      @setContentView contentView
      
      

    removeNavItems: ->
      for i in [0...@navigation.length]
        @navigation[i].destroy()
        $(".nav-#{i + 1}").remove()
      @navigation.clear()

    appendNavItem: (view) ->
      lastIndex = @navigation.length
      $("body").append "<nav class='nav-#{lastIndex + 1}'>"
      view.appendTo ".nav-#{lastIndex + 1}"
      @navigation.pushObject view
      

    setContentView: (view) ->
      @contentView?.destroy()
      view.appendTo "body"
      @contentView = view

    arrangeContent: ->
      setTimeout (=>
        marginLeft = ((@navigation.length + 1) * 200)
        $(".content").css "left", "#{marginLeft}px"
      ), 100
      $(".nav-0 li").click ({target}) ->
        $(".nav-0 li").removeClass "active"
        $(target).addClass "active"
