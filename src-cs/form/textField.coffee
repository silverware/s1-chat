define [], () ->
  Ember.View.extend
    classNames: ['control-group']
    classNameBindings: ['status']
    attributeBindings: ['placeholder', 'disabled', 'maxlength', "name"]
    value: ""
    label: ""
    status: "success"

    template: Ember.Handlebars.compile """
      <label class="control-label" for="{{view.id}}">{{view.label}}</label>
        <div class="controls">
          {{view Em.TextField valueBinding="view.value"}}
        </div>
        <span class="help-inline">{{view.message}}</span>
      """
