Chat.Button = Chat.FormFieldView.extend
  disabled: false
  template: Ember.Handlebars.compile """
    <button {{bind-attr disabled=view.disabled}} type="submit">{{view.value}}</button>
  """
