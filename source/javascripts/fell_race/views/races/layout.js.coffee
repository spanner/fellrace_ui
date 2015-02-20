class FellRace.Views.RaceLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "new_instance": @newInstance
    ":instance_name(/*path)": @instance

  edit: =>
    view = new FellRace.Views.Race
      model: @model
    _fellrace.mainRegion.show view

  default: =>
    _fellrace.closeRight()
    @edit()

  instance: (instance_name,path) =>
    @edit()
    instance = @model.instances.findWhere(name: instance_name)
    instance.fetch()
    view = new FellRace.Views.AdminInstance
      model: instance
    _fellrace.extraContentRegion.show view

  newInstance: =>
    @edit()
    instance = @model.instances.add(race_slug:@model.get("slug"))
    view = new FellRace.Views.AdminInstance
      model: instance
    _fellrace.extraContentRegion.show view
