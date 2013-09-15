Em.Select.reopen
  attributeBindings: ["name"]

Chat.SelectFieldView = FormField.extend
  template: Ember.Handlebars.compile """
    {{view Em.Select contentBinding="view.content"
        optionValuePathBinding="view.optionValue"
        optionLabelPathBinding="view.optionLabel"
        valueBinding="view.value"
    viewName="formField" nameBinding="view.viewName"}}
  """

  didInsertElement: ->
    @_super()


