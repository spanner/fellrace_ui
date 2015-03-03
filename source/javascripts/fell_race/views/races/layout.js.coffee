class FellRace.Views.RaceLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "new_instance": @newInstance
    ":instance_name(/*path)": @instance

  initialize: ->
    super
    view = new FellRace.Views.Race
      model: @model
    _fellrace.mainRegion.show view

  default: =>
    _fellrace.closeRight()

  instance: (instance_name,path) =>
    if instance = @model.past_instances.findWhere(name: instance_name)
      view = new FellRace.Views.AdminPastInstance
        model: instance
    else if instance = @model.future_instances.findWhere(name: instance_name)
      view = new FellRace.Views.AdminFutureInstance
        model: instance

    if instance
      instance.fetch()
      _fellrace.extraContentRegion.show view
    else
      $.notify "error", "This instance doesn't exist"
      _fellrace.navigate "/admin/races/#{@model.get("slug")}"

  newInstance: =>
    model = new FellRace.Models.Instance(race_slug:@model.get("slug"))
    model.urlRoot = "#{@model.url()}/instances"
    view = new FellRace.Views.NewInstance
      model: model
    _fellrace.extraContentRegion.show view

class FellRace.Views.RacesLayout extends FellRace.Views.LayoutView
  routes: =>
    ":slug(/*path)": @race

  race: (slug,path) =>
    if @_previous.route is "race" and @_previous.param is slug
      @_previous.view.handle path
    else
      model = new FellRace.Models.Race slug: slug
      _fellrace.showRace model
      model.fetch
        success: =>
          view = new FellRace.Views.RaceLayout
            model: model
            path: path
          @_previous =
            route: "race"
            param: model
            view: view
        error: =>
          _fellrace.navigate "/races/#{slug}"
