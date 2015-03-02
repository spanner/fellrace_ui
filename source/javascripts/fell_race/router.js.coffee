class FellRace.Router extends Backbone.Router

  _previous: {}

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

  _previous: {}

  public: (path) =>
    if @_previous.route is "public"
      router = @_previous.router
    else
      router = new FellRace.PublicRouter
    @_previous =
      route: "public"
      router: router
    router.handle path

  admin: (path) =>
    if @_previous.route is "admin"
      router = @_previous.router
    else
      _fellrace.vent.once "login:changed", (a, b, c) =>
        if match = Backbone.history.fragment.match(/admin(.+)/)
          if !_fellrace.userSignedIn()
            _fellrace.navigate match[1]
      router = new FellRace.AdminRouter
    @_previous =
      route: "admin"
      router: router
    router.handle path

class FellRace.PublicRouter extends FellRace.Router
  routes:
    "(/)": "index"
    "runners(/)": "competitors"
    "runners/:id(/*path)": "competitor"
    "races/:slug(/*path)": "racePublication"
    "clubs(/)": "clubs"
    "clubs/:id(/*path)": "club"
    "confirm/:uid/:token(/)": "confirmUser"
    "*path": "index"

  initialize: ->
    _fellrace.publicMapView()
    super

  index: =>
    unless @_previous.route is "index"
      _fellrace.indexMapView()
      _fellrace.race_publications.fetch()
      view = new FellRace.Views.IndexView
      _fellrace.mainRegion.show view
      _fellrace.closeRight()
      @_previous =
        route: "index"

  competitors: =>
    unless @_previous.route is "competitors"
      layout = new FellRace.Views.CompetitorsLayout
      @_previous =
        route: "competitors"

  competitor: (id,path) =>
    if @_previous.route is "competitor" and @_previous.param is id
      @_previous.view.handle path
    else
      view = new FellRace.Views.CompetitorLayout
        model: new FellRace.Models.Competitor id:id
        path: path
      @_previous =
        route: "competitor"
        param: id
        view: view

  racePublication: (slug,path) =>
    if @_previous.route is "racePublication" and @_previous.param is slug
      @_previous.view.handle path
    else
      model = _fellrace.race_publications.add(slug: slug)
      model.fetch
        success: =>
          _fellrace.vent.on 'login:changed', =>
            model.fetchPermissions()
          layout = new FellRace.Views.RacePublicationLayout
            model: model
            path: path
          @_previous =
            route: "racePublication"
            param: slug
            view: layout

  clubs: =>
    layout = new FellRace.Views.ClubsLayout
    @_previous =
      route: "clubs"

  club: (id,path) =>
    if @_previous.route is "club" and @_previous.param is id
      @_previous.view.handle path
    else
      view = new FellRace.Views.ClubLayout
        model: new FellRace.Models.Club id:id
        path: path
      @_previous =
        route: "club"
        param: id
        view: view

  confirmUser: (uid,token) =>
    _fellrace.actionRegion.show(new FellRace.Views.SessionConfirmationForm({uid: uid, token: token}))

class FellRace.AdminRouter extends FellRace.Router
  routes:
    "races/:slug(/*path)": "race"

  initialize: ->
    _fellrace.adminMapView()
    super

  race: (slug,path) =>
    if @_previous.route is "race" and @_previous.param is slug
      @_previous.view.handle path
    else
      race = new FellRace.Models.Race
        slug: slug
      _fellrace.showRace race
      race.fetch
        success: =>
          view = new FellRace.Views.RaceLayout
            model: race
            path: path
          @_previous =
            route: "race"
            param: slug
            view: view
        error: =>
          _fellrace.navigate "/races/#{slug}"

