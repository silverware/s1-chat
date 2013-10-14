Chat.ValidationMixin = Ember.Mixin.create
  insertFieldErrorMessages: (fieldErrors) ->
    for err in fieldErrors
      @insertErrorMessage err[0], err[1]

  insertErrorMessage: (field, message) ->
    field = @get field
    field.set "status", "error"
    field.set "message", message

  clearErrorMessages: (formID) ->
    inputs = @$(":input")
    for input in inputs
      name = $(input).attr "name"
      if not name then continue
      field = @get name
      if field
        field.set "status", null
        field.set "message", null

  showSuccessMessage: ->
    toastr.success "Data successfully saved"

  handleResponse: (result) ->
    if result.fieldErrors
      @insertFieldErrorMessages result.fieldErrors
    else
      @clearErrorMessages()
      @showSuccessMessage()
      @$(".icon-spinner").remove()

  save: (url, obj) ->
    @$(":button").html("&nbsp;<i class=\"icon-spinner icon-spin\"></i>")
    @$(":button").prop "disabled", true


