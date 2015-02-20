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
    "(/)": "public"
    "admin(/*path)": "admin"
    "*path": "public"

  public: (path) =>
    _fellrace.publicView()
    router = new FellRace.PublicRouter
    router.handle path

  admin: (path) =>
    _fellrace.vent.once "login:changed", (a, b, c) =>
      if match = Backbone.history.fragment.match(/admin(.+)/)
        if !_fellrace.userSignedIn()
          _fellrace.navigate match[1]

    _fellrace.adminView()
    router = new FellRace.AdminRouter
    router.handle path

class FellRace.PublicRouter extends FellRace.Router
  routes:
    "(/)": "index"
    "runners(/)": "competitors"
    "runners/:id(/*path)": "competitor"
    "races/:slug(/*path)": "racePublication"
    "clubs(/)": "clubs"
    "clubs/:id(/*path)": "club"
    "*path": "index"

  index: =>
    _fellrace.race_publications.fetch()
    index = new FellRace.Views.IndexView
    _fellrace.mainRegion.show index
    _fellrace.closeRight()

  competitors: =>
    layout = new FellRace.Views.CompetitorsLayout

  competitor: (id,path) =>
    layout = new FellRace.Views.CompetitorLayout
      model: new FellRace.Models.Competitor id:id
      path: path

  racePublication: (slug,path) =>
    model = _fellrace.race_publications.add(slug: slug)
    model.fetch
      success: =>
        _fellrace.vent.on 'login:changed', =>
          model.fetchPermissions()
        layout = new FellRace.Views.RacePublicationLayout
          model: model
          path: path
        model.trigger("select")

  clubs: =>
    layout = new FellRace.Views.ClubsLayout

  club: (id,path) =>
    layout = new FellRace.Views.ClubLayout
      model: new FellRace.Models.Club id:id
      path: path

class FellRace.AdminRouter extends FellRace.Router
  routes:
    "races/:slug(/*path)": "race"

  race: (slug,path) =>
    race = new FellRace.Models.Race
      slug: slug
    _fellrace.showRace race
    race.fetch
      success: =>
        layout = new FellRace.Views.RaceLayout
          model: race
          path: path
