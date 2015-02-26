class FellRace.Collections.Instances extends FellRace.Collection
  model: FellRace.Models.Instance

  inYearExcept: (year,instance) =>
    @filter (model) =>
      instance.id isnt model.id and model.get("year") is year

class FellRace.Collections.FutureInstances extends FellRace.Collections.Instances
  comparator: (m) ->
    m.getDate()

  onlineEntry: =>
    @filter (instance) ->
      instance.get("online_entry")

  next: =>
    @sort()
    @filter((instance)->instance.getDate())[0]

class FellRace.Collections.PastInstances extends FellRace.Collections.Instances
  comparator: (m) ->
    -m.getDate()

  mostRecent: =>
    @sort()
    @filter((instance)->instance.getDate())[0]
