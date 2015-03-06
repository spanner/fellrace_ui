class FellRace.Views.RacePublicationLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "checkpoints/:checkpoint_slug(/*path)": @checkpoint
    ":instance_name(/*path)": @instance

  handle: =>
    super
    _fellrace.vent.on 'login:changed', =>
      @model.fetchPermissions()

  initialize: ->
    @showRacePublication()
    $.r = @model
    super

  default: =>
    _fellrace.closeRight()
    @_previous =
      route: "default"

  showRacePublication: =>
    view = new FellRace.Views.RacePublication
      model: @model
    _fellrace.mainRegion.show view

  instance: (instance_name,path) =>
    if @_previous.route is "instance" and @_previous.param is instance_name
      @_previous.view.handle path
    else
      instance = @model.past_instances.findWhere(name: instance_name)
      instance ?= @model.future_instances.findWhere(name: instance_name)
      if instance
        instance.fetch
          success: =>
            instance.build()
            view = new FellRace.Views.InstanceLayout
              model: instance
              path: path
            @_previous =
              route: "instance"
              param: instance_name
              view: view
      else
        $.notify "error", "This instance doesn't exist. Redirecting to the race page."
        _fellrace.navigate "/races/#{@model.get("slug")}"

  checkpoint: (slug,path) =>
    if cp = @model.checkpoints.findWhere(slug: slug)
      _fellrace.closeRight()
      _fellrace.moveMapTo cp
    @_previous =
      route: "checkpoint"
      param: slug

class FellRace.Views.RacePublicationsLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    ":slug(/*path)": @racePublication

  default: =>
    _fellrace.closeRight()
    @_previous =
      route: "default"

  racePublication: (slug,path) =>
    if @_previous.route is "racePublication" and @_previous.param is slug
      @_previous.view.handle path
    else
      model = _fellrace.race_publications.add(slug: slug)
      model.fetch
        success: =>
          layout = new FellRace.Views.RacePublicationLayout
            model: model
            path: path
          @_previous =
            route: "racePublication"
            param: slug
            view: layout
        error: (model,response) =>
          $.getJSON "#{_fellrace.apiUrl()}/races/#{slug}/permissions", (data) =>
            if data.permissions.can_edit
              $.notify('error', "This race needs to be published.")
              _fellrace.navigate "/admin/races/#{slug}"
            else
              $.notify('error', "#{slug}.fellrace.org.uk does not exist.")
              _fellrace.navigate "/"
