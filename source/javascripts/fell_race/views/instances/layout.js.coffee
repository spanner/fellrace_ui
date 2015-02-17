class FellRace.Views.InstanceLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @results
    "entry(/)": @entry

  initialize: ->
    @model.fetch()
    super

  results: =>
    view = new FellRace.Views.InstanceResults
      model: @model
    _fellrace.extraContentRegion.show view

  edit: =>
    #TODO check for permission
    # if not permitted, redirect and warn
    # else show edit view
    # view = new FellRace.Views.CompetitorEdit
    #   el: @$el.find "#competitor"

  entry: (path) =>    
    view = new FellRace.Views.InstanceEntry
      model: @model
    _fellrace.extraContentRegion.show view
