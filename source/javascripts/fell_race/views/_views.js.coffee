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

