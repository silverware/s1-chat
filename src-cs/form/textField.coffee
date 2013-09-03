define [], () ->
  Em.TextField.reopen
    attributeBindings: ['placeholder', 'disabled', 'maxlength', "name", "type"]

  window.TextField = Ember.View.extend
    classNames: ['control-group']
    classNameBindings: ['status']
    #attributeBindings: ['placeholder', 'disabled', 'maxlength', "name"]

    template: Ember.Handlebars.compile """
      <label class="control-label" for="{{unbound view.textfield.id}}">{{view.label}}</label>
        <div class="controls">
          {{view Em.TextField valueBinding="view.value" viewName="textfield" nameBinding="view.viewName"}}
        </div>
        <span class="help-inline">{{view.message}}</span>
      """
