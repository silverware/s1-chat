Chat.VideoChatView = Chat.ContentView.extend
  template: Ember.Handlebars.compile """
    <video width='300' id='remoteview'></video>
    <video width='100 'id='selfview'></video>
  """

