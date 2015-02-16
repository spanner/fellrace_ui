class FellRace.Views.RaceAdminLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "new_instance": @newInstance
    ":instance_name(/*path)": @instance

  edit: =>
    view = new FellRace.Views.RaceAdmin
      model: @model
    _fellrace.mainRegion.show view

  default: =>
    _fellrace.closeRight()
    @edit()

  instance: (instance_name,path) =>
    instance = new FellRace.Models.Instance(name: instance_name)
    layout = new FellRace.Views.InstanceLayout
      model: instance
      path: path

  newInstance: =>
    view = new FellRace.Views.Instance
      model: new FellRace.Models.Instance({})
    _fellrace.extraContentRegion.show view
