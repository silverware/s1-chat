Chat.Router.map ->
  @resource 'chan', path: '/:chan_name'
  @route 'about'
  @route 'login'
