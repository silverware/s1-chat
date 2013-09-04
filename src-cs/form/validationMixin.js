// Generated by CoffeeScript 1.3.3

define([], function() {
  return Ember.Mixin.create({
    insertFieldErrorMessages: function(fieldErrors) {
      var err, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = fieldErrors.length; _i < _len; _i++) {
        err = fieldErrors[_i];
        _results.push(this.insertErrorMessage(err[0], err[1]));
      }
      return _results;
    },
    insertErrorMessage: function(field, message) {
      field = this.get(field);
      field.set("status", "error");
      return field.set("message", message);
    },
    clearErrorMessages: function(formID) {
      return "TODO";
      this.$(" .control-group .help-inline").remove();
      return this.$(" .error").removeClass("error");
    },
    showSuccessMessage: function() {},
    handleResponse: function(result) {
      if (result.fieldErrors) {
        return this.insertFieldErrorMessages(result.fieldErrors);
      } else {
        this.clearErrorMessages();
        return this.showSuccessMessage();
      }
    }
  });
});
