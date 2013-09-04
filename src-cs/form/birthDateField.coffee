define ["./formField", "./selectField", "./textField"], (FormField) ->

  months = ["January", "February", "March", "April", "June", "July", "August", "September", "November", "December"]

  getDays = ->
    days = []
    for i in [1..31]
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
        optionValue="content.day" optionLabel="content.day" contentBinding="view.days"}}
      {{view SelectField notSurrounded="true" valueBinding="view.month"
        optionValue="content.id" optionLabel="content.label" contentBinding="view.months"}}
      {{view TextField notSurrounded="true" valueBinding="view.year"}}
    """

    init: ->
      @_super()
