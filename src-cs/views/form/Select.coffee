Em.Select.reopen
  attributeBindings: ["name"]

Chat.Select = Chat.FormFieldView.extend
  template: Ember.Handlebars.compile """
    {{view Em.Select classNames="selectpicker" contentBinding="view.content"
        optionValuePathBinding="view.optionValuePath"
        optionLabelPathBinding="view.optionLabelPath"
        valueBinding="view.value"
    viewName="formField" nameBinding="view.viewName"}}
  """

  didInsertElement: ->
    @_super()
    @$('.selectpicker').selectpicker('show')

