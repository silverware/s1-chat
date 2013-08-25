define [
  "text!/chat_template.hbs"
  "./contentViews/chanView"
  "./queryStreamView"
  "./navigationViews/chanUsersView"
  "./popupViews/loginView"
  "./popupViews/registerView"
], (template, ChanView, QueryStreamView, ChanUsersView, LoginView, RegisterView) ->

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

      $(".registerLink").click ->
        RegisterView.create().show()

      $(".loginLink").click ->
        LoginView.create().show()
