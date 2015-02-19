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
    instance = @model.instances.findWhere(name: instance_name)
    instance.fetch()
    new FellRace.Views.Instance
      model: instance
