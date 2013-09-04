define [
  "./contentView"
], (ContentView) ->
  ContentView.extend
    template: Ember.Handlebars.compile """
      <section class="anonym">
        <button class="btn btn-large btn-primary" type="button" {{action createAnonChan target="view"}}><i class="icon-tasks"></i>create anonymous channel</button>
      </section>
    <section class="public">
      {{#each chan in view.publicChans}}
        <div class="join-chan" {{action join chan target="Chat"}}>{{chan}}</div>
      {{/each}}
    </section>

    """
    classNames: ['content home']
    navId: "home"
    publicChans: []

    init: ->
      @_super()
      $.get "/ajax/chans", (chans) =>
        @set "publicChans", chans

    didInsertElement: ->
      @_super()

    createAnonChan: ->
      $.post "/chan/create", ({chanName}) ->
        Chat.join chanName

