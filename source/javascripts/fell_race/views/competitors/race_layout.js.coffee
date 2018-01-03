class FellRace.Views.CompetitorRaceView extends Backbone.Marionette.ItemView
  template: "competitors/race"

  # bindings:
  #   "a.name": "name"

  onRender: =>
    @stickit()
    #TODO show performances list for this competitor at this race

class FellRace.Views.CompetitorRaceLayout extends FellRace.Views.LayoutView
  initialize: ({competitor:@competitor}={}) ->
    super

  routes: =>
    "(/)": @default
    ":instance_name(/*path)": @instance

  default: =>
    view = new FellRace.Views.CompetitorRaceView
      model: @model
      competitor: @competitor
    _fr.extraContentRegion.show view
    @_previous =
      route: "default"

  instance: (instance_name,path) =>
    if @_previous.route is "instance" and @_previous.param is instance_name
      @_previous.view.handle path
    else
      instance = @model.past_instances.findWhere(name: instance_name)
      instance.fetch
        success: =>
          view = new FellRace.Views.InstanceLayout
            model: instance
            competitor: @competitor
            path: path
          @_previous =
            route: "instance"
            param: instance_name
            view: view
