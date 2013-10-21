Chat.WebCamPopup = Chat.PopupView.extend
  template: Ember.Handlebars.compile """
  <h4>Take webcam picture</h4>
       <div class="tab-pane active" id="webcam-pane">
        <div id="photobooth" style="width: 400px; height: 300px"></div>
        <div id="preview"></div>
        <button >TAKE PICTURE</button>
        <button {{action hide target="view"}} >CANCEL</button>
     </div>
  """


  didInsertElement: ->
    @_super()
    $('#photobooth').photobooth().on "image", (event, dataUrl) ->
      $("#preview").append "<img src='#{dataUrl}' />"


  onPictureTaken: ->
