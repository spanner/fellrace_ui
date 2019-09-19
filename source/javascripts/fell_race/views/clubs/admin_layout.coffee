class FellRace.Views.AdminClubsLayout extends FellRace.Views.LayoutView
  routes: =>
    "(/)": @index

  index: =>
    unless @_previous.route is "index"
      more_view = new FellRace.Views.AdminClubsTable
      _fr.extraContentRegion.show more_view
      @_previous =
        route: "index"
