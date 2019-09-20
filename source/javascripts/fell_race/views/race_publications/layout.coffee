class FellRace.Views.RacePublicationLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "checkpoints/:checkpoint_slug(/*path)": @checkpoint
    "history(/*path)": @history
    ":instance_name(/*path)": @instance

  handle: =>
    super
    @_radio.on 'login:changed', =>
      @model.fetchPermissions()

  initialize: ->
    _fr.mainRegion.show new FellRace.Views.RacePublication
      model: @model
    $.r = @model
    super

  default: =>
    _fr.closeRight()
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
        _fr.broadcast "error", "This instance doesn't exist. Redirecting to the race page."
        _fr.navigate "/races/#{@model.get("slug")}", replace:true

  checkpoint: (slug,path) =>
    if cp = @model.checkpoints.findWhere(slug: slug)
      _fr.closeRight()
      _fr.moveMapTo cp
    @_previous =
      route: "checkpoint"
      param: slug

  history: (path) =>
    view = new FellRace.Views.RaceHistory
      model: @model
    _fr.extraContentRegion.show view
    @_previous =
      route: "history"

class FellRace.Views.RacePublicationsLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @index
    ":slug(/*path)": @racePublication

  index: =>
    _fr.mainRegion.show new FellRace.Views.RacePublicationsIndex
      collection: _fr.race_publications
    _fr.closeRight()
    @_previous =
      route: "index"

  racePublication: (slug,path) =>
    model = _fr.race_publications.add(slug: slug)
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
        $.getJSON "#{_fr.apiUrl()}/races/#{slug}/permissions", (data) =>
          if data.permissions.can_edit
            _fr.broadcast('error', "This race needs to be published.")
            _fr.navigate "/admin/races/#{slug}", replace:true
          else
            _fr.broadcast('error', "#{slug}.fellrace.org.uk does not exist.")
            _fr.navigate "/", replace:true
