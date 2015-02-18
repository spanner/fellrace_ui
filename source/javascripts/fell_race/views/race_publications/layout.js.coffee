class FellRace.Views.RacePublicationLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    ":instance_name(/*path)": @instance

  default: =>
    _fellrace.closeRight()
    @show()

  show: =>
    console.log @model
    view = new FellRace.Views.RacePublication
      model: @model
    _fellrace.mainRegion.show view

  instance: (instance_name,path) =>
    @show()
    console.log instance_name, @model.instances
    instance = @model.instances.findWhere(name: instance_name)
    instance.fetch()
    new FellRace.Views.Instance
      model: instance
