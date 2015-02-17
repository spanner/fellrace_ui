class FellRace.Views.AdminRaceLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "new_instance": @newInstance
    ":instance_name(/*path)": @instance

  edit: =>
    view = new FellRace.Views.AdminRace
      model: @model
    _fellrace.mainRegion.show view

  default: =>
    _fellrace.closeRight()
    @edit()

  instance: (instance_name,path) =>
    instance = new FellRace.Models.Instance(name: instance_name)
    instance.fetch()
    layout = new FellRace.Views.AdminInstanceLayout
      model: instance
      path: path

  newInstance: =>
    view = new FellRace.Views.AdminInstance
      model: new FellRace.Models.Instance({})
    _fellrace.extraContentRegion.show view
