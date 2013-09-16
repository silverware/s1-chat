Chat.IndexView = Chat.ContentView.extend
  template: Ember.Handlebars.compile """
    <section class="anonym">
      <button class="btn btn-large btn-primary" type="button" {{action createAnonChan}}><i class="icon-tasks"></i>create anonymous channel</button>
    </section>
  <section class="public">
    {{#each}}
      <div class="join-chan" {{action join name target='Chat'}}>{{name}} ({{users}})</div>
    {{/each}}
  </section>

  """
  classNames: ['content home']

  didInsertElement: ->
    @_super()



