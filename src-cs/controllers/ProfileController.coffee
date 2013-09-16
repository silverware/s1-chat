Chat.ProfileController = Ember.ObjectController.extend Chat.ValidationMixin,
  save: ->
    $.post "/ajax/user/", {user: @get('model') , "session-id": Chat.ticket["session-id"]}, (result) =>
      @handleResponse result

  changePassword: ->
    $.post "/ajax/user/" + Chat.ticket.username + "/password", {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
      @handleResponse result
