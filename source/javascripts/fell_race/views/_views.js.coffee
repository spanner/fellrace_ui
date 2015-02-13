class FellRace.Views.LayoutView extends Backbone.Marionette.Layout
  routes: =>
    {}

  initialize: ({path:path}={}) ->
    path ?= "/"
    @_segment = null
    @_child = null
    @_router = new FellRace.Router
      routes: _.result(this, 'routes')
    @_router.handle(path)
