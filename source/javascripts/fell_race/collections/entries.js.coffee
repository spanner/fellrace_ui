class FellRace.Collections.Entries extends FellRace.Collection
  model: FellRace.Models.Entry

  comparator: (model) ->
    [model.get('surname'), model.get('forename')].join(' ').toLowerCase()

  postalCount: =>
    @length - @onlineCount()

  online: =>
    @filter (e) -> e.get("paid") and !e.get("cancelled")

  onlineCount: =>
    @online().length

  present: (opts) =>
    @filter((item) ->
      item.get("forename")?.toLowerCase() is opts.forename?.toLowerCase() and
      item.get("middlename")?.toLowerCase() is opts.middlename?.toLowerCase() and
      item.get("surname")?.toLowerCase() is opts.surname?.toLowerCase() and
      item.get("dob") is opts.dob and
      item.get("gender") is opts.gender).length
