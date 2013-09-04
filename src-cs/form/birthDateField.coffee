define ["./formField", "./selectField", "./textField"], (FormField) ->

  months = ["january", "February", "March", "April", "june", "july", "august", "september", "november", "december"]

  getDays = ->
    days = []
    for i in [0..31]
      days.pushObject day: i
    days

  days = getDays()
  months = months.map (m, i) -> Em.Object.create(id: i, label: m)

  window.BirthDateField = FormField.extend
    type: "text"
    date: new Date()
    days: days
    months: months

    template: Ember.Handlebars.compile """
      {{view SelectField notSurrounded="true" valueBinding="view.day"
        optionValue="day" optionLabel="day" contentBinding="view.days"}}
      {{view SelectField notSurrounded="true" valueBinding="view.month"
        optionValue="id" optionLabel="label" contentBinding="view.months"}}
      {{view TextField notSurrounded="true" valueBinding="view.year"}}
    """

    init: ->
      @_super()
