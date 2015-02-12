class FellRace.Collections.Instances extends FellRace.Collection
  model: FellRace.Models.Instance

  url: =>
    if @race
      "#{@race.url()}/instances"      
    else
      "#{_fellrace.apiUrl()}/api/instances"

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
