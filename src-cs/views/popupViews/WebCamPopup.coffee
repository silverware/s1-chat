Chat.WebCamPopup = Chat.PopupView.extend
  classNames: ['popup-container']
  template: Ember.Handlebars.compile """
    <div class="poputent">halloooo</div>
       <div class="tab-pane active" id="webcam-pane">
        <div id="photobooth" style="width: 400px; height: 400px"></div>
        <div id="preview"></div>
        <button >TAKE PICTURE</button>
     </div>
  """


  didInsertElement: ->
    @_super()
    $('#photobooth').photobooth().on "image", (event, dataUrl) ->
      $("#preview").append "<img src='#{dataUrl}' />"
