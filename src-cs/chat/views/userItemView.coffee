define ->
  Ember.View.extend
    user: null
    template: Ember.Handlebars.compile """{{user}}"""
    classNames: ['username']

    didInsertElement: ->
      @$().popover
        placement: "left"
        trigger: "click"
        title: @user
        html: true
        content: """<i class="icon-remove"></i>hier kommt was"""
      

