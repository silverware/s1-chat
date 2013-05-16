define [
  "./userItemView"
  "text!/chan_users_template.hbs"
], (UserItemView, template) ->
  Ember.View.extend
    chan: null
    UserItemView: UserItemView

    template: Ember.Handlebars.compile template
    classNames: ['users']

    didInsertElement: ->
      # todo
      

