class FellRace.Views.RacePublicationLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "checkpoints/:checkpoint_slug(/*path)": @checkpoint
    "history(/*path)": @history
    ":instance_name(/*path)": @instance

  handle: =>
    super
    _fellrace.vent.on 'login:changed', =>
      @model.fetchPermissions()

  initialize: ->
    _fellrace.mainRegion.show new FellRace.Views.RacePublication
      model: @model
    $.r = @model
    super

  default: =>
    _fellrace.closeRight()
    @_previous =
      route: "default"

  instance: (instance_name,path) =>
    if @_previous.route is "instance" and @_previous.param is instance_name
      @_previous.view.handle path
    else
      instance = @model.past_instances.findWhere(name: instance_name)
      instance ?= @model.future_instances.findWhere(name: instance_name)
      if instance
        if instance.populated
          view = new FellRace.Views.InstanceLayout
            model: instance
            path: path
          @_previous =
            route: "instance"
            param: instance_name
            view: view
        else
          instance.set fetching:true
          instance.fetch().done =>
            instance.build()
            instance.populated = true
            instance.set fetching:false
            @instance instance_name,path
      else
        $.notify "error", "This instance doesn't exist. Redirecting to the race page."
        _fellrace.navigate "/races/#{@model.get("slug")}", replace:true

  checkpoint: (slug,path) =>
    if cp = @model.checkpoints.findWhere(slug: slug)
      _fellrace.closeRight()
      _fellrace.moveMapTo cp
    @_previous =
      route: "checkpoint"
      param: slug

  history: (path) =>
    view = new FellRace.Views.RaceHistory
      model: @model
    _fellrace.extraContentRegion.show view
    @_previous =
      route: "history"

class FellRace.Views.RacePublicationsLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @index
    ":slug(/*path)": @racePublication

  index: =>
    _fellrace.mainRegion.show new FellRace.Views.RacePublicationsIndex
      collection: _fellrace.race_publications
    _fellrace.closeRight()
    @_previous =
      route: "index"

  racePublication: (slug,path) =>
    model = _fellrace.race_publications.add(slug: slug)
    model.fetch
      success: =>
        if @_previous.route is "racePublication" and @_previous.param is slug
          @_previous.view.handle path
        else          
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
            _fellrace.navigate "/admin/races/#{slug}", replace:true
          else
            $.notify('error', "#{slug}.fellrace.org.uk does not exist.")
            _fellrace.navigate "/", replace:true
