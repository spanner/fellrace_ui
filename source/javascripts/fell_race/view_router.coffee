# The ViewRouter is a subclass of the usual backbone router that detaches it from the History object.
# Instead of passing handlers into History, it keeps them locally and exposes a `handle` method
# that when given the current url fragment will call the first matching handler.
#
# Apart from that we use the standard router mechanism so all the usual path and parameter-definition rules apply.
#
# This allows us to create a router local to a view and call it with a path fragment. We use it to support
# iterative descent through a series of layout views each with its own router object mapping paths to functions.
#
class FellRace.ViewRouter extends Backbone.Router

  initialize: (options) ->
    @_view = options.view

  handle: (fragment="/") =>
    _.any @handlers, (handler) ->
      if handler.route.test(fragment)
        handler.callback(fragment)
        true

  route: (route, name, fn) =>
    route = @_routeToRegExp(route) unless _.isRegExp(route)
    if _.isFunction(name)
      fn = name
      name = ''
    unless fn?
      fn = this[name]
    @handlers = []
    @handlers.unshift
      route: route
      callback: (fragment) =>
        args = @_extractParameters(route, fragment)
        @execute(fn, args, name)

