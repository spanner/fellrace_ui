class FellRace.Router extends Backbone.Router

  _previous: {}

  constructor: ->
    @handlers = []
    super

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
    if _fellrace.userSignedIn()
      if @_previous.route is "admin"
        @_previous.router.handle path
      else
        router = new FellRace.AdminRouter
        router.handle path
        @_previous =
          route: "admin"
          router: router
      _fellrace.vent.once "login:changed", =>
        _fellrace.toPublicOrHome()
    else if _fellrace.authPending()
      _fellrace.vent.once "login:changed", =>
        @admin path
    else
      _fellrace.toPublicOrHome()

class FellRace.PublicRouter extends FellRace.Router
  routes:
    "(/)": "index"
    "races(/*path)": "racePublications"
    "runners(/*path)": "competitors"
    "clubs(/*path)": "clubs"
    "users(/*path)": "users"
    "confirm/:uid/:token(/)": "confirmUser"
    "faq/:page_name(/)": "page"
    "*path": "index"

  initialize: ->
    _fellrace.publicMapView()
    super

  index: =>
    unless @_previous.route is "index"
      _fellrace.indexMapView()
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
    if _fellrace.userSignedIn()
      if @_previous.route is "users"
        @_previous.view.handle path
      else
        view = new FellRace.Views.UsersLayout
          path: path
        @_previous =
          route: "users"
          view: view
      _fellrace.vent.on "login:changed", =>
        _fellrace.navigate "/"
    else
      if _fellrace.authPending()
        _fellrace.vent.once "login:changed", =>
          @users path
      else
        _fellrace.navigate "/"

  confirmUser: (uid,token) =>
    @index()
    _fellrace.actionRegion.show(new FellRace.Views.SessionConfirmationForm({uid: uid, token: token}))

  page: (page_name) =>
    view = new FellRace.Views.Page
      template: "pages/#{page_name}"
    _fellrace.indexMapView()
    _fellrace.mainRegion.show view
    _fellrace.closeRight()

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
