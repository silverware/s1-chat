Chat.IndexView = Chat.ContentView.extend
  template: Ember.Handlebars.compile """
    <section class="anonym">
      <button class="btn btn-large btn-primary" type="button" {{action createAnonChan target="view"}}><i class="icon-tasks"></i>create anonymous channel</button>
    </section>
  <section class="public">
    {{#each}}
      <div class="join-chan" {{action join chan.name target="Chat"}}>{{chan.name}} ({{chan.users}})</div>
    {{/each}}
  </section>

  """
  classNames: ['content home']
  navId: "home"

  didInsertElement: ->
    @_super()

  createAnonChan: ->
    $.post "/chan/create", ({chanName}) ->
      Chat.join chanName

