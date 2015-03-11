class FellRace.Views.AdminClubsLayout extends FellRace.Views.LayoutView
  routes: =>
    "(/)": @index

  index: =>
    unless @_previous.route is "index"
      view = new FellRace.Views.AdminClubsTable
      _fellrace.extraContentRegion.show view
      @_previous =
        route: "index"
        view: view
