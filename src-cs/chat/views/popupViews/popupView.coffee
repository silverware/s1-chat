define ->

  Ember.View.extend
    classNames: ['popup-container']
    layout: Ember.Handlebars.compile """
      <div class="popup-content" style="display: none">{{yield}}</div>
    """

    didInsertElement: ->
      $(document).keyup((e) =>
        if e.keyCode == 27
          $(".popup-container").remove()
      )
     
      popupContent = @$(".popup-content")

      popupContent.css("position","absolute")
      popupContent.css("top", Math.max(0, (($(window).height() - popupContent.outerHeight()) / 2) + $(window).scrollTop()) + "px")
      popupContent.css("left", Math.max(0, (($(window).width() - popupContent.outerWidth()) / 2) + $(window).scrollLeft()) + "px")
      
      $(".popup-content").fadeIn()

    show: ->
      @appendTo "body"
