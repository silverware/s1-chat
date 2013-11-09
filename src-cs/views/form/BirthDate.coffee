Chat.BirthDate = Chat.FormFieldView.extend
  type: "text"
  date: new Date()
  days: [{day: ""}].concat [1..31].map (d) -> {day: d}
  months: [{id: "", label: ""}].concat ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"].map (m, i) -> {id: i+1 , label: m}
  label: "Birthdate"

  template: Ember.Handlebars.compile """
    {{view Em.Select valueBinding="view.day" style="width: 60px" name="birthdate-day"
      optionValuePath="content.day" optionLabelPath="content.day" contentBinding="view.days"}}
    {{view Em.Select valueBinding="view.month" style="width: 120px" name="birthdate-month"
      optionValuePath="content.id" optionLabelPath="content.label" contentBinding="view.months"}}
    {{view Em.TextField valueBinding="view.year" style="width: 60px" name="birthdate-year" maxlength="4" placeholder="yyyy"}}
  """
  init: ->
    @_super()
