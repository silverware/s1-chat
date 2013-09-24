Em.Select.reopen
  attributeBindings: ["name"]

Chat.Select = Chat.FormFieldView.extend
  template: Ember.Handlebars.compile """
    {{view Em.Select classNames="selectpicker" contentBinding="view.content"
        optionValuePathBinding="view.optionValuePath"
        optionLabelPathBinding="view.optionLabelPath"
        valueBinding="view.value"
    viewName="formField" nameBinding="view.viewName"}}
    <select class="selectpicker2"><option value="1">hallo</option><option value="2">Huhu</option>
    </select>
  """

  didInsertElement: ->
    @_super()
    @$('.selectpicker').selectpicker()

