Chat.IndexView = Chat.ContentView.extend
  template: Ember.Handlebars.compile """
    <section class="anonym">
      <button class="btn btn-large btn-primary" type="button" {{action createAnonChan}}><i class="icon-tasks"></i>create anonymous channel</button>
    </section>
  <section class="public">
    {{#each}}
      {{#link-to 'chan' name tagName="div" class="join-chan"}}{{name}} ({{users}}){{/link-to}}
    {{/each}}
  </section>

  """
  classNames: ['content home']

  didInsertElement: ->
    @_super()



