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
    "(/)": @show
    ":instance_name(/)": @instance

  show: =>
    view = new FellRace.Views.CompetitorRaceView
      model: @model
      competitor: @competitor
    _fellrace.extraContentRegion.show view

  instance: (instance_name) =>
    instance = @model.past_instances.findWhere name: instance_name
    instance.fetch
      success: =>
        view = new FellRace.Views.InstanceResults
          model: instance
          competitor: @competitor
        _fellrace.extraContentRegion.show view
