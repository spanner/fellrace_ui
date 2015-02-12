class FellRace.Collections.Checkpoints extends FellRace.Collection
  model: FellRace.Models.Checkpoint
  comparator: "pos"

  initialize: (models) ->
    super
    @resequence_soon = _.debounce @resequence, 200
    @on "add", (point, collection) =>
      @checkRoutability()
      @resequence_soon()
    @on "remove", (point, collection) =>
      @checkRoutability()
      @resequence_soon()
    @on "change:lat", () =>
      @checkRoutability()

  add: (models, options) =>
    options ?= {}
    options['at'] = @length - 1
    super(models, options)
    @trigger('reset')

  names: =>
    names = []
    for cp in @models
      name = cp.get "name"
      times = cp.get "times"
      if times
        unless name == "Start"
          names.push name
    names

  resequence: () =>
    cpt.set('pos', i) for cpt, i in @models

  checkRoutability: () =>
    if @validAsRoute() then @trigger('routable') else @trigger('unroutable')

  validAsRoute: () =>
    placed = @pluck('placed')
    _.first(placed) and _.last(placed) and _.compact(placed).length >= 3

  toGooglePoints: () =>
    points = @map (cpt) ->
      cpt.getLatLng()
    _.compact(points)

  getColour: =>
    @race.getColour()

  setRaceCheckpointRoute: =>
    console.log "setRaceCheckpointRoute"
    cps = @filter (cp) ->
      cp.has("lat") and cp.has("lng")

    path = cps.map (cp) ->
      cp.getLatLng()
    @race.set
      encoded_checkpoint_route: MapStick.encodePathString(path)