Chat.User = Em.Object.extend
  username: ""

Chat.User.reopenClass
  find: (id) ->
    Ember.$.get
