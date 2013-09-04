define ["./formField"], (FormField) ->
  Em.TextArea.reopen
    attributeBindings: ['maxlength', "name"]

  window.TextArea = FormField.extend
    template: Ember.Handlebars.compile """
      {{view Em.TextArea valueBinding="view.value"
      viewName="formField" nameBinding="view.viewName"}}
    """
