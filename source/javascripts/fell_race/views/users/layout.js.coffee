class FellRace.Views.UserLayout extends FellRace.Views.LayoutView
  initialize: ->
    super
    view = new FellRace.Views.User
      model: @model
    _fellrace.mainRegion.show view

  default: =>
    _fellrace.closeRight()
    @_previous =
      route: "default"

class FellRace.Views.UsersLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "me(/*path)": @me
    ":id(/*path)": @user

  default: =>
    _fellrace.closeRight()
    $.notify "error", "no 'users' page yet"
    @_previous =
      route: "default"

  me: (path) =>
    if _fellrace.userSignedIn()
      if @_previous.route is "me"
        @_previous.view.handle path
      else
        model = _fellrace.currentUser()
        model.fetch
          success: =>
            view = new FellRace.Views.UserLayout
              model: model
              path: path
            @_previous =
              route: "me"
              view: view
    else
      _fellrace.vent.once "login:changed", =>
        @me path

  user: (id,path) =>
    if @_previous.route is "user" and @_previous.param is id
      @_previous.view.handle path
    else
      model = new FellRace.Models.User id:id
      model.fetch
        success: =>
          view = new FellRace.Views.UserLayout
            model: model
            path: path
          @_previous =
            route: "user"
            param: id
            view: view
