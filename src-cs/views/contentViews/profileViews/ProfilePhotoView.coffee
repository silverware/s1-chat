Chat.ProfilePhotoView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  showPreview: false
  template: Ember.Handlebars.compile """
    {{view Chat.ProfileNavView}}
    <h1>Upload Photo</h1>


     <form class="form-horizontal" {{action "uploadImage" target="view" on="submit"}}>
      <div class="control-group">
       <label class="control-label">current image</label>
        <div class="controls"><img id="current-image" style="height: 100px" /></div>
       </div>
       <div class="control-group">
       <label class="control-label">new image</label>
        <div class="controls"><button {{action openWebcamPopup target="view"}} type="button">take webcam picture</button></div>
       </div>
      {{view Chat.FileSelect label="Select an image" viewName="image"}}
      <div class="control-group image-preview" {{bind-attr class="showPreview:show:hide"}} >
        <label class="control-label">preview</label>
        <div class="controls"><img id="image-preview" style="height: 100px" /></div>
       </div>
      {{view Chat.Button disabled="true" viewName="saveButton" value="Upload Photo"}}
     </form>

     <div class=""></div>


  """

  selection:
    x: 30
    y: 30
    w: 50

  actions:
    uploadImage: ->
      @disableButtons @$("form"), true
      formData = new FormData()
      formData.append "image", @selectedImage
      formData.append "username", Chat.ticket.username
      formData.append "session-id", Chat.ticket["session-id"]
      formData.append "x", @selection.x
      formData.append "y", @selection.y
      formData.append "wh", @selection.w

      $.ajax
        type: "POST"
        url: "/ajax/user/image"
        data: formData
        contentType: false
        processData: false
        success: (result) =>
          @disableButtons @$("form"), false
          @handleResponse result
          @setCurrentImage()

    openWebcamPopup: ->
      console.debug "huhu"
      Chat.WebCamPopup.create
        onPictureTaken: (file) =>
          console.debug file


  didInsertElement: ->
    @_super()
    @setCurrentImage()

  onImageValueChange: (->
    if not @get "image.value" then return
    @get("saveButton").set "disabled", false
    @selectedImage = @$("input[name='image']")[0].files[0]
    console.debug @selectedImage
    @$("#image-preview").prop "src", URL.createObjectURL @selectedImage
    @set "showPreview", true
    @$("#image-preview").Jcrop
      aspectRatio: 1/1
      setSelect: [ 33, 33, 66, 66 ]
      onSelect: (e) =>
        @set "selection", e
  ).observes("image.value")

  setCurrentImage: ->
    @$("#current-image").prop "src", "/ajax/user/#{Chat.ticket.username}/image?no-cache=#{Math.random()}"




