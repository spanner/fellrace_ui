class FellRace.Views.ClubLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "edit(/)": @edit
    ":race_slug(/*path)": @race

  initialize: ->
    @model.fetch()
    super

  show: =>
    view = new FellRace.Views.Club
      model: @model
    _fellrace.mainRegion.show view

  default: =>
    _fellrace.extraContentRegion.close()
    @show()

  edit: =>
    #TODO check for permission
    # if not permitted, redirect and warn
    # else show edit view
    # view = new FellRace.Views.CompetitorEdit
    #   el: @$el.find "#competitor"

  race: (race_slug,path) =>
    @show()
    race = new FellRace.Models.Race(slug: race_slug)
    layout = new FellRace.Views.ClubRaceLayout
      model: race
      club: @model
      path: path
