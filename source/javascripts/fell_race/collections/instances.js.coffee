class FellRace.Collections.Instances extends FellRace.Collection
  model: FellRace.Models.Instance

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
