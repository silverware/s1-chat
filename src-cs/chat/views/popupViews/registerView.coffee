define [
  "text!/register_template.hbs",
  "./popupView"
  "./loginView"
], (template, PopupView, LoginView) ->
  PopupView.extend
    template: Ember.Handlebars.compile template
    classNames: ['register']

    insertErrorMessage: (field, message) ->
      controlGroup = @$('#' + field).parent().parent()
      controlGroup.addClass 'error'
      @$('<span class="help-inline">' + message + '</span>').insertAfter @$('#'+ field)

    clearErrorMessages: ->
      @$(".control-group .help-inline").remove()
      @$(".error").removeClass("error")

    didInsertElement: ->
      @_super()

      @$("#register-form").submit (event) =>
        @clearErrorMessages()
        event.preventDefault()
        formData = @$("#register-form").serialize()
        
        buttonHTML = @$(":button").html()
        @$(":button").html("&nbsp;<i class=\"icon-spinner icon-spin\"></i>")

        $.post('/register', formData, (data) =>
          @$(":button").html(buttonHTML)

          if data.fieldErrors
            for entry in data.fieldErrors
              @insertErrorMessage(entry[0], entry[1])

          else if data.errors
            alert data.errors
          else
            alert "ok"
        , "json")


      
   
 
