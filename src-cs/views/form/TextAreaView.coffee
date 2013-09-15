Em.TextArea.reopen
  attributeBindings: ['maxlength', "name"]

Chat.TextAreaView = Chat.FormFieldView.extend
  template: Ember.Handlebars.compile """
    {{view Em.TextArea valueBinding="view.value"
    viewName="formField" nameBinding="view.viewName"}}
  """
