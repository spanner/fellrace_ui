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
    "races(/*path)": "racePublications"
    "runners(/*path)": "competitors"
    "clubs(/*path)": "clubs"
    "users(/*path)": "users"
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

  racePublications: (path) =>
    if @_previous.route is "race_publications"
      @_previous.view.handle path
    else
      view = new FellRace.Views.RacePublicationsLayout
        path: path
      @_previous =
        route: "race_publications"
        view: view

  competitors: (path) =>
    if @_previous.route is "competitors"
      @_previous.view.handle path
    else
      view = new FellRace.Views.CompetitorsLayout
        path: path
      @_previous =
        route: "competitors"
        view: view

  clubs: (path) =>
    if @_previous.route is "clubs"
      @_previous.view.handle path
    else
      view = new FellRace.Views.ClubsLayout
        path: path
      @_previous =
        route: "clubs"
        view: view

  users: (path) =>
    if @_previous.route is "users"
      @_previous.view.handle path
    else
      view = new FellRace.Views.UsersLayout
        path: path
      @_previous =
        route: "users"
        view: view

  confirmUser: (uid,token) =>
    _fellrace.actionRegion.show(new FellRace.Views.SessionConfirmationForm({uid: uid, token: token}))

class FellRace.AdminRouter extends FellRace.Router
  routes:
    "races(/*path)": "races"

  initialize: ->
    _fellrace.adminMapView()
    super

  races: (path) =>
    if @_previous.route is "races"
      @_previous.view.handle path
    else
      view = new FellRace.Views.RacesLayout
        path: path
      @_previous =
        route: "races"
        view: view
