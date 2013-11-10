Chat.ContentView = Ember.View.extend
  classNames: ['content']

  layout: Ember.Handlebars.compile """
    {{#if title}}
    <div class="content-title">{{title}}</div>
    {{/if}}
    {{yield}}
  """

  init: ->
    @_super()
    if @notSurrounded
      @classNames.removeObject "control-group"
      @set "layout", Ember.Handlebars.compile "{{yield}}"


  didInsertElement: ->
    @_super()
