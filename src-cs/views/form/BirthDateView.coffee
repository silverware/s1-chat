Chat.BirthDateView = Chat.FormFieldView.extend
  type: "text"
  date: new Date()
  days: [1..31].map (d) -> {day: d}
  months = ["January", "February", "March", "April", "June", "July", "August", "September", "November", "December"].map (m, i) -> Em.Object.create(id: i, label: m)
  label: "Birthdate"

  template: Ember.Handlebars.compile """
    {{view Em.Select notSurrounded="true" valueBinding="view.day"
      optionValuePath="content.day" optionLabelPath="content.day" contentBinding="view.days"}}
    {{view Em.Select notSurrounded="true" valueBinding="view.month"
      optionValuePath="content.id" optionLabelPath="content.label" contentBinding="view.months"}}
    {{view Em.TextField valueBinding="view.year"}}
  """

  init: ->
    @_super()
