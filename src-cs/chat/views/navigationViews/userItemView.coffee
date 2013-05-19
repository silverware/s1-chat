define ->
  Ember.View.extend
    user: null
    template: Ember.Handlebars.compile """<img src="img/dummy.png" />&nbsp;&nbsp;{{user}}"""
    classNames: ['username']

    didInsertElement: ->
      @$().popover
        placement: "left"
        trigger: "click"
        title: @user
        html: true
        content: """<i class="icon-remove"></i>hier kommt was"""
      

