Em.Select.reopen
  attributeBindings: ["name", "size", "style"]

Chat.Select = Chat.FormFieldView.extend
  size: 1
  template: Ember.Handlebars.compile """
    {{view Em.Select classNames="selectpicker" contentBinding="view.content"
        optionValuePathBinding="view.optionValuePath"
        optionLabelPathBinding="view.optionLabelPath"
        valueBinding="view.value" sizeBinding="view.size"
    viewName="formField" nameBinding="view.viewName"}}
  """

  didInsertElement: ->
    @_super()
    console.debug "Lkj"
    #@$('.selectpicker').selectBox()

