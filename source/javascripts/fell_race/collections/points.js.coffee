class FellRace.Collections.Points extends FellRace.Collection
  model: FellRace.Models.Point
  comparator: "pos"

  initialize: (models) ->
    super
    # The only thing we manage here is position-within-collection,
    # but we need the route (map kind) to calculate our nested route (url kind) on the server
    @resequence_soon = _.debounce @resequence, 200
    @on "add", (point, collection) =>
      @resequence_soon()
    @on "remove", (point, collection) =>
      @resequence_soon()
    @resequence()

  # #todo: this can trigger a lot of individual saves. Batched collection-save would be helpful.
  resequence: () =>
    point.set('pos', i) for point, i in @models
