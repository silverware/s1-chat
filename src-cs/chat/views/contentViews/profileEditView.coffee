define [
  "text!/profile_edit_template.hbs"
  "./contentView"
], (template, ContentView) ->
  ContentView.extend
    template: Ember.Handlebars.compile template
    navId: "editProfile"

    didInsertElement: ->
      @_super()
      # todo

