define ->

  Ember.View.extend
    classNames: ['popup-container']
    layout: Ember.Handlebars.compile """
      <div class="popup-content">{{yield}}</div>
    """

    didInsertElement: ->
      #todo

    show: ->
      @appendTo "body"