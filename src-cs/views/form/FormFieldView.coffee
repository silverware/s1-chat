Chat.FormFieldView = Ember.View.extend
  classNames: ['control-group']
  classNameBindings: ['status']
  
  notSurrounded: false
  status: ""

  layout: Ember.Handlebars.compile """
    <label class="control-label" for="{{unbound view.formField.id}}">{{view.label}}</label>
      <div class="controls" view-name="{{unbound view.viewName}}">
        {{yield}}
        <span class="help-inline">{{view.message}}</span>
      </div>
  """

  init: ->
    @_super()
    if @notSurrounded
      @classNames.removeObject "control-group"
      @set "layout", Ember.Handlebars.compile "{{yield}}"

