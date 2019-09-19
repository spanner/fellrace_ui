class FellRace.Views.UserLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "preferences(/*path)": @prefs

  default: =>
    view = new FellRace.Views.User
      model: @model
    _fr.mainRegion.show view
    _fr.closeRight()

  prefs: =>
    view = new FellRace.Views.UserPrefs
      model: @model
    _fr.mainRegion.show view
    _fr.closeRight()


class FellRace.Views.UsersLayout extends FellRace.Views.LayoutView
  routes: () =>
    # "(/)": @index
    "me(/*path)": @me
    ":id(/*path)": @user

  # index: =>
  #   _fr.closeRight()
  #   @_previous =
  #     route: "index"

  me: (path) =>
    if @_previous.route is "me"
      @_previous.view.handle path
    else
      model = _fr.getCurrentCompetitor()
      model.fetch
        success: =>
          view = new FellRace.Views.CompetitorLayout
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
