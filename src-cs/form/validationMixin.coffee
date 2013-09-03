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
        @$(formID + " .control-group .help-inline").remove()
        @$(formID + " .error").removeClass("error")

      getFormFields: ->


      handleResponse: (result) ->
        @insertFieldErrorMessages result.fieldErrors

