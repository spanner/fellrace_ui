class FellRace.Collections.Entries extends FellRace.Collection
  model: FellRace.Models.Entry

  postalCount: =>
    @length - @onlineCount()

  online: =>
    @where paid: true

  onlineCount: =>
    @online().length

  present: (opts) =>
    @filter((item) ->
      item.get("forename")?.toLowerCase() is opts.forename?.toLowerCase() and
      item.get("middlename")?.toLowerCase() is opts.middlename?.toLowerCase() and
      item.get("surname")?.toLowerCase() is opts.surname?.toLowerCase() and
      item.get("dob") is opts.dob and
      item.get("gender") is opts.gender).length
