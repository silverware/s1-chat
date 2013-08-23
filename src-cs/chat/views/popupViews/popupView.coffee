define ->

  Ember.View.extend
    classNames: ['popup-container']
    layout: Ember.Handlebars.compile """
      <div class="popup-content">{{yield}}</div>
    """

    didInsertElement: ->
      $(document).keyup((e) =>
        if e.keyCode == 27
          $(".popup-container").remove()
      )

    show: ->
      @appendTo "body"
