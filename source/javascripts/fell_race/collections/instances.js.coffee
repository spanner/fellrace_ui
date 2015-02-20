class FellRace.Collections.Instances extends FellRace.Collection
  model: FellRace.Models.Instance
  comparator: (m) ->
    -m.getDate()

  past: =>
    _.filter @models, (instance) =>
      instance.inPast()

  future: =>
    _.filter @models, (instance) =>
      instance.inFuture()

  onlineEntry: =>
    _.filter @future(), (instance) =>
      instance.get("online_entry")

  inYearExcept: (year,instance) =>
    _.filter @models, (model) =>
      instance.id isnt model.id and model.get("year") is year

  next: =>
    @sort()
    future = @future()
    if future.length > 0
      future[0]

  mostRecent: =>
    @sort()
    past = @past()
    if past.length > 0
      past.reverse()[0]
