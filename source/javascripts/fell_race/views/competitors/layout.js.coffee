class FellRace.Views.CompetitorLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "edit(/)": @edit
    ":race_slug(/*path)": @race

  initialize: ->
    @model.fetch()
    super

  default: =>
    _fellrace.closeRight()
    @show()

  edit: =>
    #TODO check for permission
    # if not permitted, redirect and warn
    # else show edit view
    # view = new FellRace.Views.CompetitorEdit
    #   el: @$el.find "#competitor"

  show: =>
    view = new FellRace.Views.Competitor
      model: @model
    _fellrace.mainRegion.show view

  race: (race_slug,path) =>
    @show()
    race = new FellRace.Models.RacePublication(slug: race_slug)
    race.fetch
      success: =>
        layout = new FellRace.Views.CompetitorRaceLayout
          model: race
          competitor: @model
          path: path
