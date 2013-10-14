Chat.ProfilePhotoView = Chat.ContentView.extend Chat.ValidationMixin,
  classNames: ['content-2']
  template: Ember.Handlebars.compile """
    {{view Chat.ProfileNavView}}
    <h1>Upload Photo</h1>
    <ul id="login-tabs" class="nav nav-tabs">
     <li class="active p33"> <a href="#webcam-pane" data-toggle="tab">Webcamera</a></li>
     <li class="p33"><a href="#upload-img" data-toggle="tab">Upload</a></li>
     <li class="p33"><a href="#register-pane" data-toggle="tab">Gravatar</a></li>
    </ul>
    <div class="tab-content">
     <div class="tab-pane active" id="webcam-pane">
        <div id="photobooth" style="width: 400px; height: 400px"></div>
        <div id="preview"></div>
        <button >TAKE PICTURE</button>
     </div>

     <div class="tab-pane" id="upload-img">
     <form class="form-horizontal" {{action "uploadImage" target="view" on="submit"}}>
      {{view Chat.FileSelect label="Select an image" viewName="image"}}
      {{view Chat.Button value="Upload Photo"}}
     </form>
      </div>

     <div class="tab-pane" id="register-pane">
     <form class="form-horizontal" id="register-form">
      {{view Chat.TextField label="E-Mail" viewName="email"}}
      {{view Chat.TextField label="Username" viewName="username"}}
      {{view Chat.TextField label="Password" viewName="password1" type="password"}}
      {{view Chat.TextField label="Password (repeat)" viewName="password2" type="password"}}
      <button type="submit">Submit</button>
     </form>
      </div>
      </div>
      <button type="submit">Save Changes</button>

  """
  actions:
    uploadImage: ->
      formData = new FormData()
      formData.append "image", @selectedImage
      formData.append "username", Chat.ticket.username
      formData.append "session-id", Chat.ticket["session-id"]

      $.ajax
        type: "POST"
        data: formData
        contentType: false
        processData: false
        success: (result) => @handleResponse result

  didInsertElement: ->
    @_super()
    $('#photobooth').photobooth().on "image", (event, dataUrl) ->
      $("#preview").append "<img src='#{dataUrl}' />"

  onImageValueChange: (->
    if not @get "image.value" then return
    @selectedImage = @$("input[name='image']")[0].files[0]
  ).observes("image.value")


