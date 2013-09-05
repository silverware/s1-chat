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
