class FellRace.Views.RaceLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    ":instance_name(/*path)": @instance

  initialize: ({slug:@slug,path:path}) ->
    super

  default: =>
    _fellrace.closeRight()
    @show()

  admin: (path) =>
    _fellrace.closeRight()
    @model = new FellRace.Models.Race
      slug: @slug
    @model.fetch()
    view = new FellRace.Views.RaceAdminLayout
      model: @model
      path: path

    #TODO check for permission
    # if not permitted, redirect and warn
    # else show edit view
    # view = new FellRace.Views.RaceAdmin
    #   el: @$el.find "#competitor"

  show: =>
    @model = new FellRace.Models.Race
      slug: @slug
    @model.fetch()
    view = new FellRace.Views.Race
      model: @model
    _fellrace.mainRegion.show view

  instance: (instance_name,path) =>
    @show()
    instance = new FellRace.Models.Instance(name: instance_name, {race:@model})
    new FellRace.Views.Instance
    # new FellRace.Views.InstanceLayout
    #   model: instance
    #   path: path
