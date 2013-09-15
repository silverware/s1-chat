Chat.ApplicationController = Ember.Controller.extend
  navigationViews: []
  contentView: null
  view: null

  init: ->
    @_super()

  openHome: ->
    @removeNavItems()
    @setContentView HomeView.create()

  openChan: (chan) ->
    if not Chat.get("isAuthenticated") then return LoginView.create()
    @removeNavItems()

    contentView = ChanView.create chan: chan
    usersView = ChanUsersView.create chan: chan

    @appendNavItem usersView
    @setContentView contentView

  openEditProfile: ->
    @removeNavItems()
    @setContentView ProfileEditView.create()

  removeNavItems: ->
    for i in [0...@navigationViews.length]
      @navigationViews[i].destroy()
      $(".nav-#{i + 1}").remove()
    @navigationViews.clear()

  appendNavItem: (view) ->
    lastIndex = @navigationViews.length
    $("body").append "<nav class='nav-#{lastIndex + 1}'>"
    view.appendTo ".nav-#{lastIndex + 1}"
    @navigationViews.pushObject view

  setContentView: (view) ->
    @contentView?.destroy()
    view.appendTo "body"
    @set "contentView", view
    navId = view.get "navId"
    $(".nav-0 li").removeClass "active"
    setTimeout (-> $(".nav-0 li[nav-id='#{navId}']").addClass "active"), 10


  arrangeContent: ->
    marginLeft = ((@navigationViews.length + 1) * 220)
    $(".content").css "left", "#{marginLeft}px"

