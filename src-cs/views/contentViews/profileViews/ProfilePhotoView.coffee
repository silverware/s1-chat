Chat.ProfilePhotoView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  template: Ember.Handlebars.compile """
    <h1>Upload Photo</h1>

    <form class="form-horizontal" {{action "uploadImage" target="view" on="submit"}}>
      <div class="control-group">
        <label class="control-label">current image</label>
        <div class="controls"><img id="current-image" style="height: 100px" /></div>
      </div>
      <div class="control-group">
        <label class="control-label">new image</label>
        <div class="controls">
          <button {{action openWebcamPopup target="view"}} type="button">webcam picture</button>
          <button {{action openDiscUpload target="view"}} type="button">upload from disk</button>
        </div>

       </div>
      <div style="display: none">{{view Chat.FileSelect label="Select an image" viewName="image"}}</div>
      <div class="control-group image-preview" {{bind-attr class="showPreview:show:hide"}} >
        <label class="control-label">preview</label>
        <div class="controls"><img id="image-preview" style="height: 100px" /></div>
       </div>
      {{view Chat.Button disabled="true" viewName="saveButton" value="Upload Photo"}}
     </form>
  """

  showPreview: false
  selection:
    x: 30
    y: 30
    w: 50

  actions:
    uploadImage: ->
      previewImage = @$('#image-preview')
      previewWidth = previewImage.width()
      previewHeight = previewImage.height()

      img = new Image()
      img.onload = () =>
        @disableButton @get('saveButton'), true
        formData = new FormData()
        formData.append "image", @selectedImage
        formData.append "username", Chat.ticket.username
        formData.append "session-id", Chat.ticket["session-id"]
        formData.append "x", @selection.x * img.width / previewWidth
        formData.append "y", @selection.y * img.height / previewHeight
        formData.append "wh", @selection.w * img.width / previewWidth

        $.ajax
          type: "POST"
          url: "/ajax/user/image"
          data: formData
          contentType: false
          processData: false
          success: (result) =>
            @disableButton @get('saveButton'), false
            @handleResponse result
            @setCurrentImage()

      fr = new FileReader
      fr.readAsDataURL(@selectedImage)

      fr.onload = () ->
        img.src = fr.result

    openWebcamPopup: ->
      @removePreview()
      Chat.WebCamPopup.create
        onPictureTaken: (file) =>
          @openPreview file

    openDiscUpload: ->
      @$("input[name='image']").click()


  didInsertElement: ->
    @_super()
    @setCurrentImage()

  onImageValueChange: (->
    if not @get "image.value" then return
    @selectedImage = @$("input[name='image']")[0].files[0]
    @openPreview URL.createObjectURL @selectedImage
  ).observes("image.value")

  openPreview: (src) ->
    @removePreview()
    @get("saveButton").set "disabled", false
    @$("#image-preview").prop "src", src
    @set "showPreview", true

    self = @
    @$("#image-preview").Jcrop
      aspectRatio: 1/1
      setSelect: [ 33, 33, 66, 66 ]
      onSelect: (e) =>
        @set "selection", e
      , -> self.jcropper = @

  removePreview: ->
    @$("#image-preview").prop "src", ""
    if @jcropper then @jcropper.destroy()
    @get("saveButton").set "disabled", true


  setCurrentImage: ->
    @$("#current-image").prop "src", "/ajax/user/#{Chat.ticket.username}/image?no-cache=#{Math.random()}"




