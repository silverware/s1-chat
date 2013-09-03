define [
  "./contentView"
  "form/textField"
  "form/validationMixin"
], (ContentView, TextField, Validation) ->
  ContentView.extend Validation,
    template: Ember.Handlebars.compile """
    <form class="form-horizontal">
      {{view TextField valueBinding="view.user.email" viewName="email" label="Email"}}
      <button {{action "save" target="view"}} type="submit">Lutscher</button>
     </form>
    """
    navId: "editProfile"
    user: {}

    init: ->
      @_super()
      $.get("/ajax/user/" + Chat.ticket.username, (result) =>
        @set("user", result)
      )

    save: () ->
      $.post "/ajax/user/" + Chat.ticket.username, {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
        @handleResponse result

    didInsertElement: ->
      @_super()

      # todo

