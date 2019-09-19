class FellRace.Views.CompetitorLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @show
    ":race_slug(/*path)": @race

  initialize: ->
    super
    view = new FellRace.Views.Competitor
      model: @model
    _fr.mainRegion.show view

  show: =>
    _fr.closeRight()
    @_previous =
      route: "default"

  race: (race_slug,path) =>
    if @_previous.route is "race" and @_previous.param is race_slug
      @_previous.view.handle path
    else
      race = new FellRace.Models.RacePublication(slug: race_slug)
      race.fetch
        success: =>
          view = new FellRace.Views.CompetitorRaceLayout
            model: race
            competitor: @model
            path: path
          @_previous =
            route: "race"
            param: race_slug
            view: view


class FellRace.Views.CompetitorsLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    ":id(/*path)": @competitor

  default: =>
    _fr.closeRight()
    _fr.broadcast "error", "no 'runners' page yet"
    @_previous =
      route: "default"

  competitor: (id,path) =>
    if @_previous.route is "competitor" and @_previous.param is id
      @_previous.view.handle path
    else
      model = new FellRace.Models.Competitor id:id
      model.fetch
        success: =>
          view = new FellRace.Views.CompetitorLayout
            model: model
            path: path
          @_previous =
            route: "competitor"
            param: id
            view: view
