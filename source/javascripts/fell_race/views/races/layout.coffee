class FellRace.Views.RaceLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "new_instance": @newInstance
    ":instance_name(/*path)": @instance

  initialize: ->
    super
    view = new FellRace.Views.Race
      model: @model
    _fr.mainRegion.show view

  default: =>
    _fr.noExtraView()

  instance: (instance_name,path) =>
    if instance = @model.past_instances.findWhere(name: instance_name)
      view = new FellRace.Views.AdminPastInstance
        model: instance
    else if instance = @model.future_instances.findWhere(name: instance_name)
      view = new FellRace.Views.AdminFutureInstance
        model: instance

    if instance
      instance.fetch()
      _fr.extraContentRegion.show view
    else
      _fr.broadcast "error", "This instance doesn't exist"
      _fr.navigate "/admin/races/#{@model.get("slug")}", replace:true

  newInstance: =>
    model = new FellRace.Models.Instance(race_slug:@model.get("slug"),race_name:@model.get("name"))
    model.urlRoot = "#{@model.url()}/instances"
    view = new FellRace.Views.NewInstance
      model: model
    _fr.extraContentRegion.show view


class FellRace.Views.RacesLayout extends FellRace.Views.LayoutView
  routes: =>
    ":slug(/*path)": @race

  race: (slug,path) =>
    if @_previous.route is "race" and @_previous.param is slug
      @_previous.view.handle path
    else
      model = new FellRace.Models.Race slug: slug
      model.fetch
        success: =>
          _fr.showRace model
          view = new FellRace.Views.RaceLayout
            model: model
            path: path
          @_previous =
            route: "race"
            param: model
            view: view
        error: =>
          _fr.navigate "/races/#{slug}"
