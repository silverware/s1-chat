Chat.Router.map ->
  @route 'about'
  @route 'login'
  @resource 'chan', path: '/chan/:chan_name'
  @route 'profile'

Chat.Router.reopen
  location: 'history'

