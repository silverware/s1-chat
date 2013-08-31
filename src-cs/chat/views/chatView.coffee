define [
  "text!/chat_template.hbs"
  "./contentViews/chanView"
  "./queryStreamView"
  "./navigationViews/chanUsersView"
  "./popupViews/loginView"
], (template, ChanView, QueryStreamView, ChanUsersView, LoginView) ->

  Ember.View.extend
    ChanView: ChanView
    QueryStreamView: QueryStreamView
    ChanUsersView: ChanUsersView
    template: Ember.Handlebars.compile template
    classNames: ['chat']

    init: ->
      @_super()
      @appendTo "body"

    didInsertElement: ->
      @$("[nav-id='home']").click =>
        Chat.controller.openHome()

      @$("[nav-id='edit-profile']").click =>
        console.log "edit profile"
        Chat.controller.openEditProfile()

    openLoginPopup: (action = "login") ->
        LoginView.create({initialTab: action}).show()
