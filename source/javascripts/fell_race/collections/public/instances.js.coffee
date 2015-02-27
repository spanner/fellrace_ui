class FellRace.Collections.PublicInstances extends FellRace.Collection
  model: FellRace.Models.PublicInstance
  comparator: (m) ->
    -m.getDate()

class FellRace.Collections.PublicFutureInstances extends FellRace.Collections.PublicInstances
  comparator: (m) ->
    m.getDate()

class FellRace.Collections.PublicPastInstances extends FellRace.Collections.PublicInstances
  comparator: (m) ->
    -m.getDate()
