class FellRace.Collections.PublicInstances extends FellRace.Collection
  model: FellRace.Models.PublicInstance
  comparator: (m) ->
    -m.getDate()
