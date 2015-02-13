class FellRace.Router extends Backbone.Router
  constructor: ->
    @handlers = []
    super

  handle: (fragment) =>
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
    
    @handlers.unshift
      route: route
      callback: (fragment) =>
        args = @_extractParameters(route, fragment)
        @execute(fn, args, name)


class FellRace.BaseRouter extends Backbone.Router
  routes:
    "(/)": "index"
    "runners(/)": "competitors"
    "runners/:id(/*path)": "competitor"
    "races/:slug(/*path)": "race"
    "clubs(/)": "clubs"
    "clubs/:id(/*path)": "club"
    "*path": "index"

  index: =>
    index = new FellRace.Views.IndexView
    _fellrace.mainRegion.show index
    _fellrace.closeRight()

  competitors: =>
    layout = new FellRace.Views.CompetitorsLayout

  competitor: (id,path) =>
    layout = new FellRace.Views.CompetitorLayout
      model: new FellRace.Models.Competitor id:id
      path: path

  race: (slug,path) =>
    layout = new FellRace.Views.RaceLayout
      slug: slug
      path: path

  clubs: =>
    layout = new FellRace.Views.ClubsLayout

  club: (id,path) =>
    layout = new FellRace.Views.ClubLayout
      model: new FellRace.Models.Club id:id
      path: path
