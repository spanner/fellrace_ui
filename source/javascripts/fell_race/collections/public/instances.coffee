class FellRace.Collections.PublicInstances extends FellRace.Collection
  model: FellRace.Models.PublicInstance
  comparator: (m) ->
    -m.getDate()


class FellRace.Collections.PublicFutureInstances extends FellRace.Collections.PublicInstances
  url: ->
    "#{_fr.apiUrl()}/instances/future"

  comparator: (m) ->
    m.getDate()
  
  next: =>
    @sort()
    @filter((instance)->instance.getDate())[0]


class FellRace.Collections.PublicPastInstances extends FellRace.Collections.PublicInstances
  url: ->
    "#{_fr.apiUrl()}/instances/past"

  comparator: (m) ->
    -m.getDate()

  mostRecent: =>
    @sort()
    @filter((instance)->instance.getDate())[0]
