class FellRace.Views.UserLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "preferences(/*path)": @prefs

  default: =>
    view = new FellRace.Views.User
      model: @model
    _fellrace.mainRegion.show view
    _fellrace.closeRight()

  prefs: =>
    view = new FellRace.Views.UserPrefs
      model: @model
    _fellrace.mainRegion.show view
    _fellrace.closeRight()


class FellRace.Views.UsersLayout extends FellRace.Views.LayoutView
  routes: () =>
    # "(/)": @index
    "me(/*path)": @me
    ":id(/*path)": @user

  # index: =>
  #   _fellrace.closeRight()
  #   @_previous =
  #     route: "index"

  me: (path) =>
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
