define [
  "text!/profile_edit_template.hbs"
], (template) ->
  Ember.View.extend
    template: Ember.Handlebars.compile template

    didInsertElement: ->
      # todo
      
    partChan: ->
      @chan.part()
      Chat.view.openHome()
