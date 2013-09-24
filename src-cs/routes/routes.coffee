Chat.Router.map ->
  @route 'about'
  @route 'login'
  @resource 'chan', path: '/chan/:chan_name'
  @resource 'profile', ->
    @route 'password'
    @route 'photo'

Chat.Router.reopen
  location: 'history'
