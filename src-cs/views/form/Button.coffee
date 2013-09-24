Chat.Button = Chat.FormFieldView.extend

  template: Ember.Handlebars.compile """
    <button type="submit">{{view.value}}</button>
  """
