class FellRace.Views.RacePublicationLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    ":instance_name(/*path)": @instance

  default: =>
    _fellrace.closeRight()
    @show()

  show: =>
    view = new FellRace.Views.RacePublication
      model: @model
    _fellrace.mainRegion.show view

  instance: (instance_name,path) =>
    @show()
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
