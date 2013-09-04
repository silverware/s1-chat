define ->
  Em.TextField.reopen
    attributeBindings: ['placeholder', 'disabled', 'maxlength', "name", "type"]

  window.TextField = Ember.View.extend
    classNames: ['control-group']
    classNameBindings: ['status']
    type: "text"

    template: Ember.Handlebars.compile """
      <label class="control-label" for="{{unbound view.textfield.id}}">{{view.label}}</label>
        <div class="controls">
          {{view Em.TextField valueBinding="view.value" placeholderBinding="view.placeholder"
          viewName="textfield" nameBinding="view.viewName"
          disabledBinding="view.disabled" typeBinding="view.type"}}
          <span class="help-inline">{{view.message}}</span>
        </div>
      """
