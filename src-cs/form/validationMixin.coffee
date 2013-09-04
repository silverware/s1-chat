define [], () ->
  Ember.Mixin.create
    insertFieldErrorMessages: (fieldErrors) ->
      for err in fieldErrors
        @insertErrorMessage err[0], err[1]

    insertErrorMessage: (field, message) ->
      field = @get field
      field.set "status", "error"
      field.set "message", message

    clearErrorMessages: (formID) ->
      return "TODO"
      @$(" .control-group .help-inline").remove()
      @$(" .error").removeClass("error")

    showSuccessMessage: ->

    handleResponse: (result) ->
      if result.fieldErrors
        @insertFieldErrorMessages result.fieldErrors
      else
        @clearErrorMessages()
        @showSuccessMessage()


