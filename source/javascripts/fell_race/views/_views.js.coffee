class FellRace.Views.LayoutView extends Backbone.Marionette.Layout
  routes: =>
    {}

  _previous: {}

  initialize: ({path:path}={}) ->
    @_router = new FellRace.Router
      routes: _.result(this, 'routes')
    @handle(path)

  handle: (path) ->
    path ?= "/"
    @_router.handle(path)


class FellRace.Views.CollectionFilter extends Backbone.Marionette.ItemView
  template: false

  bindings:
    ":el": "term"

  initialize: ->
    @model = new Backbone.Model

  onRender: =>
    @stickit()
    matcher = (model, term) =>
      @$el.addClass "working"
      if term
        @collection.each (model) ->
          model.set unmatched: model.unmatches(term)
      else
        @clearMatches()
      @$el.removeClass "working"

    @model.on "change:term", _.debounce(matcher, 250)

  clearMatches: =>
    @collection.each (model) -> model.unset "unmatched"

  onBeforeDestroy: =>
    @clearMatches()
