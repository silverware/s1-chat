Chat.PopupView = Ember.View.extend
  classNames: ['popup-container']
  layout: Ember.Handlebars.compile """
    <div class="popup-content">{{yield}}</div>
  """

  init: ->
    @_super()
    @appendTo "body"

  actions:
    hide: ->
      @hide()

  didInsertElement: ->
    $(document).keyup (e) =>
      if e.keyCode is 27
        @hide()

    popupContent = @$(".popup-content")

    popupContent.css "position", "absolute"
    #popupContent.css("top", Math.max(0, (($(window).height() - popupContent.outerHeight()) / 2) + $(window).scrollTop()) + "px")
    #popupContent.css("left", Math.max(0, (($(window).width() - popupContent.outerWidth()) / 2) + $(window).scrollLeft()) + "px")

    $(".popup-content").fadeIn()

  hide: ->
    $(".popup-container").fadeOut "fast", =>
      @destroy()

