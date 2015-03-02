class FellRace.Views.RacePublicationLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "checkpoints/:checkpoint_slug(/*path)": @checkpoint
    ":instance_name(/*path)": @instance

  initialize: ->
    @showRacePublication()
    $.r = @model
    super

  default: =>
    _fellrace.closeRight()

  showRacePublication: =>
    view = new FellRace.Views.RacePublication
      model: @model
    _fellrace.mainRegion.show view

  instance: (instance_name,path) =>
    if @_previous.route is "instance" and @_previous.param is instance_name
      @_previous.view.handle path
    else
      instance = @model.past_instances.findWhere(name: instance_name)
      instance = @model.future_instances.findWhere(name: instance_name) unless instance
      if instance
        instance.fetch
          success: =>
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

  checkpoint: (checkpoint_slug,path) =>
    if cp = @model.checkpoints.findWhere(slug: checkpoint_slug)
      _fellrace.closeRight()
      _fellrace.moveMapTo cp
