define [
  "./contentView"
], (ContentView) ->
  ContentView.extend
    template: Ember.Handlebars.compile """
    <form action="" class="form-horizontal" method="POST">
      <div class="control-group">
        <label class="control-label" for="email">E-Mail</label>
        <div class="controls">
          {{view Em.TextField valueBinding="view.user.email" id="email"}}
        </div>
      </div>
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
      $.post("/ajax/user/" + Chat.ticket.username, {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
        )

    didInsertElement: ->
      @_super()
      
      # todo

