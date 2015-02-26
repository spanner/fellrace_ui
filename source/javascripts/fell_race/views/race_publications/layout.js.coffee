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
    view = null
    if instance = @model.past_instances.findWhere(name: instance_name)
      view = new FellRace.Views.InstanceResults
        model: instance
      _fellrace.extraContentRegion.show(view)
    else
      instance = @model.future_instances.findWhere(name: instance_name)
      _fellrace.extraContentRegion.close()
      console.log "entries page?" #TODO entries page
    instance.fetch()
