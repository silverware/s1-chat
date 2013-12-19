Chat.VideoView = Chat.ContentView.extend
  template: Ember.Handlebars.compile """
    <h1>HUHU</h1>
    <video width='300' id='remoteview'></video>
    <video width='100 'id='selfview'></video>
  """

  didInsertElement: ->
    @onStreamRemoteOpened()
    @onStreamSelfOpened()


  onStreamRemoteOpened: ->
    console.debug @get("controller.model")
    @$("#remoteview").attr "src", URL.createObjectURL(@get("controller.model.streamRemote"))
    @$("#remoteview").get(0).play()


  onStreamSelfOpened: ->
    @$("#selfview").attr "src", URL.createObjectURL(@get("controller.model.streamSelf"))
    @$("#selfview").get(0).play()
