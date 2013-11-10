Em.TextField.reopen
  attributeBindings: ["style", 'placeholder', 'disabled', 'maxlength', "name", "type"]

Chat.TextField = Chat.FormFieldView.extend
  type: "text"

  template: Ember.Handlebars.compile """
    {{view Em.TextField valueBinding="view.value" placeholderBinding="view.placeholder"
    nameBinding="view.viewName"
    disabledBinding="view.disabled" typeBinding="view.type"}}
  """

