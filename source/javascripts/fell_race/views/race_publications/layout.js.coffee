class FellRace.Views.RacePublicationLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "checkpoints/:checkpoint_slug(/*path)": @checkpoint
    ":instance_name(/*path)": @instance

  initialize: ->
    @showRacePublication()
    $.r = @model
    super

  default: =>
    _fellrace.closeRight()

  showRacePublication: =>
    view = new FellRace.Views.RacePublication
      model: @model
    _fellrace.mainRegion.show view

  instance: (instance_name,path) =>
    if instance = @model.past_instances.findWhere(name: instance_name)
      view = new FellRace.Views.InstanceResults
        model: instance
    else if instance = @model.future_instances.findWhere(name: instance_name)
      view = new FellRace.Views.FutureInstance
        model: instance
    if instance
      instance.fetch()
      _fellrace.extraContentRegion.show(view)
    else
      $.notify "error", "This instance doesn't exist. Redirecting to the race page."
      _fellrace.navigate "/races/#{@model.get("slug")}"

  checkpoint: (checkpoint_slug,path) =>
    if cp = @model.checkpoints.findWhere(slug: checkpoint_slug)
      _fellrace.closeRight()
      _fellrace.moveMapTo cp
