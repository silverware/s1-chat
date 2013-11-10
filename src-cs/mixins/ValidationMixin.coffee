Chat.ValidationMixin = Ember.Mixin.create
  insertFieldErrorMessages: (fieldErrors) ->
    for err in fieldErrors
      @insertErrorMessage err[0], err[1]

  insertErrorMessage: (field, message) ->
    field = @get field
    field.set "status", "error"
    field.set "message", message

  clearErrorMessages: (formID) ->
    inputs = @$("[view-name]")
    for input in inputs
      field = @get $(input).attr "view-name"
      field.set "status", null
      field.set "message", null

  showSuccessMessage: ->
    toastr.success "Data successfully saved"

  handleResponse: (result) ->
    @clearErrorMessages()
    if result.fieldErrors
      @insertFieldErrorMessages result.fieldErrors
    else
      @showSuccessMessage()

  save: (url, obj, onResponse) ->
    $.post url, obj, (response) =>
      @handleResponse response
      if onResponse then onResponse response

  disableButtons: (form, disable) ->
    if disable
      @tempButtonLabel = form.find(":button").html()
      form.find(":button").html("<i class=\"icon-spinner icon-spin\"></i>")
    else
      form.find(":button").html @tempButtonLabel
    form.find(":button").prop "disabled", disable

  handleFormSubmit: (form) ->
    if not form.prop "action" then return
    form.submit (event) =>
      event.preventDefault()
      @disableButtons form, true
      @save form.prop("action"), form: form.serializeForm(), ticket: Chat.ticket, (response) =>
        @disableButtons form, false

  didInsertElement: ->
    @_super()
    @$("form").each (i, form) =>
      @handleFormSubmit $ form



