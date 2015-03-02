class FellRace.Views.CompetitorLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    ":race_slug(/*path)": @race

  initialize: ->
    super
    view = new FellRace.Views.Competitor
      model: @model
    _fellrace.mainRegion.show view

  default: =>
    _fellrace.closeRight()
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
