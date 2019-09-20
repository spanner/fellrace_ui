class FellRace.Views.ClubLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    ":race_slug(/*path)": @race

  initialize: ->
    super
    view = new FellRace.Views.Club
      model: @model
    _fr.mainRegion.show view

  default: =>
    _fr.noExtraView()
    @_previous =
      route: "default"

  race: (race_slug,path) =>
    race = new FellRace.Models.Race(slug: race_slug)
    layout = new FellRace.Views.ClubRaceLayout
      model: race
      club: @model
      path: path
    @_previous =
      route: "race"



class FellRace.Views.ClubsLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    ":id(/)": @club

  default: =>
    _fr.noExtraView()
    _fr.broadcast "error", "no 'runners' page yet"
    @_previous =
      route: "default"

  club: (id,path) =>
    if @_previous.route is "club" and @_previous.param is id
      @_previous.view.handle path
    else
      model = new FellRace.Models.Club id:id
      model.fetch
        success: =>          
          view = new FellRace.Views.ClubLayout
            model: model
            path: path
          @_previous =
            route: "club"
            param: id
            view: view
