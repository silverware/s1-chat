Em.TextField.reopen
  attributeBindings: ['placeholder', 'disabled', 'maxlength', "name", "type"]

Chat.TextFieldView = Chat.FormFieldView.extend
  type: "text"

  template: Ember.Handlebars.compile """
    {{view Em.TextField valueBinding="view.value" placeholderBinding="view.placeholder"
    viewName="formField" nameBinding="view.viewName"
    disabledBinding="view.disabled" typeBinding="view.type"}}
  """
