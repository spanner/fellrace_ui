class FellRace.AppRouter extends Backbone.Router
  routes:
    "(/)": "index"
    "faq/:page_name(/)": "page"
    "races(/*path)": "race"
    "runners(/*path)": "runner"
    "users(/*path)": "user"
    "confirm/:uid/:token(/)": "confirmUser"
    "reset_password/:uid/:token(/)": "resetPassword"
    "admin/races(/*path)": "adminRace"
    "admin/clubs(/*path)": "adminClubs"
    "admin/runners(/*path)": "adminRunners"
    "*path": "index"

  initialize: (opts={}) ->
    @_ui = opts.ui

  index: =>
    @_ui.showIndex()

  page: (page_name) =>
    @_ui.showPage(page_name)

  race: (path) =>
    @_ui.showRace(path)

  runner: (path) =>
    @_ui.showRunner(path)

  user: (path) =>      
    @_ui.showUser(path)

  confirmUser: (uid,token) =>
    @_ui.confirmUser(uid, token)

  resetPassword: (uid,token) =>
    @_ui.resetPassword(uid, token)

  adminRace: (path) =>
    @_ui.showAdminRace(path)

  adminClubs: (path) =>
    @_ui.showAdminClubs(path)

  adminRunners: (path) =>
    @_ui.showAdminRunners(path)

