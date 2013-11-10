Chat.Router.map ->
  @route 'about'
  @route 'login'
  @resource 'chan', path: '/chan/:chan_name'
  @resource 'video', path: '/video/:username'
  @resource 'profile', ->
    @route 'password'
    @route 'photo'

Chat.Router.reopen
  location: 'history'
