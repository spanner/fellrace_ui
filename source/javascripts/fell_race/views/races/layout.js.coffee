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
    instance = @model.past_instances.findWhere(name: instance_name)
    instance = @model.future_instances.findWhere(name: instance_name) unless instance
    instance.fetch()
    view = new FellRace.Views.AdminInstance
      model: instance
    _fellrace.extraContentRegion.show view

  newInstance: =>
    @edit()
    model = new FellRace.Models.Instance(race_slug:@model.get("slug"))
    model.urlRoot = "#{@model.url()}/instances"
    view = new FellRace.Views.NewInstance
      model: model
    _fellrace.extraContentRegion.show view
