Chat.ProfilePhotoView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  template: Ember.Handlebars.compile """
    {{view Chat.ProfileNavView}}
    <h1>Upload Photo</h1>


    TODO: PHOto upload: webcam
  """
  actions:
    save: ->
      $.post "/ajax/user/", {user: @get('controller.model') , "session-id": Chat.ticket["session-id"]}, (result) =>
        @handleResponse result

  changePassword: ->
    $.post "/ajax/user/" + Chat.ticket.username + "/password", {user: @user, "session-id": Chat.ticket["session-id"]}, (result) =>
      @handleResponse result

  didInsertElement: ->
    @_super()

