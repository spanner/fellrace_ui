class FellRace.Collections.Entries extends FellRace.Collection
  model: FellRace.Models.Entry

  postalCount: =>
    @length - @onlineCount()

  online: =>
    @where paid: true

  onlineCount: =>
    @online().length
