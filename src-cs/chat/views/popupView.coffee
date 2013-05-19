define ->

  Ember.View.extend
    classNames: ['popup']
    layout: Ember.Handlebars.compile """
      <div class="popup-container">
        <div class="popup-content">{{yield}}</div>
      </div>
    """

    didInsertElement: ->
      #todo

