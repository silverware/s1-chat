define ->

  validate = (form) ->
    form.validate
      highlight: (label) ->
        $(label).closest('.control-group').addClass('error')
      success: (label) ->
        label.closest('.control-group').removeClass('error')
      rules:
        publicName:
          required: true
          remote: 
            url: "/tournament/checkPublicName"
            data:
              publicName: -> $("#inputPublicName").val()
    form.valid()
     

  $.extend $.validator.messages,
    required: "Dieses Feld ist erforderlich.",
    remote: "Please fix this field.",
    email: "Please enter a valid email address.",
    url: "Please enter a valid URL.",
    date: "Please enter a valid date.",
    dateISO: "Please enter a valid date (ISO).",
    number: "Please enter a valid number.",
    digits: "Please enter only digits.",
    creditcard: "Please enter a valid credit card number.",
    equalTo: "Please enter the same value again.",
    accept: "Please enter a value with a valid extension.",
    maxlength: jQuery.validator.format("Maximal {0} Zeichen möglich."),
    minlength: jQuery.validator.format("Mindestens {0} Zeichen möglich."),
    rangelength: jQuery.validator.format("Please enter a value between {0} and {1} characters long."),
    range: jQuery.validator.format("Please enter a value between {0} and {1}."),
    max: jQuery.validator.format("Please enter a value less than or equal to {0}."),
    min: jQuery.validator.format("Please enter a value greater than or equal to {0}.")


  class Save
    
    ajax: true
    url: null
    form: ""

    constructor: (args) ->
      $.extend(@, args)
      @init()

    init: ->
      @form.submit (event) =>

        if validate @form

          if @ajax
            #@startLoading()
            event.preventDefault()

            @url = @form.attr 'action' if not @url

            if typeof @data == 'function'
              data = @data()
              console.debug data
              $.ajax
                type: "POST"
                url: @url
                data: JSON.stringify(data)
                contentType: "application/json; charset=utf-8"
                success: @_onSave
                error: @_onError
            else
              data = @form.serialize()
              $.post @url, data, @_onSave
        else
          event.preventDefault()

    _onSave: (response) =>
      @form.find("button").removeAttr('disabled')
      #@stopLoading()
      #@showSuccess true
      @onSave response

    _onError: =>
      window.location.href = "/error"

    onSave: =>
      # Extension-Point

    startLoading: ->
      console.debug @form.find("button")
      @form.find("button").attr('disabled', 'disabled')
      $(".ajaxLoader").fadeIn("fast")

    stopLoading: ->
      @showSuccess false
      $(".ajaxLoader").hide()
      
    showSuccess: (show) ->
      if not show
        $(".successIcon").hide()
      else 
        $(".successIcon").fadeIn("medium")
        setTimeout((-> $(".successIcon").fadeOut("fast")), 5000)
