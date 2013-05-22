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
      @appendTo "body"

    didInsertElement: ->
      @$("[nav-id='home']").click =>
        @openHome()
      $(".loginLink").click ->
        LoginView.create().show()
      @openHome()

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
      @set "contentView", view
      navId = view.get "navId"
      $(".nav-0 li").removeClass "active"
      console.debug navId
      setTimeout (-> $(".nav-0 li[nav-id='#{navId}']").addClass "active"), 10


    arrangeContent: ->
      marginLeft = ((@navigation.length + 1) * 220)
      $(".content").css "left", "#{marginLeft}px"
      
