class FellRace.Collections.Entries extends FellRace.Collection
  model: FellRace.Models.Entry

  paid: =>
    @where(paid: true)

  paidCount: =>
    @paid().length

  pending: =>
    @where
      paid: false
      accepted: false

  pendingCount: =>
    @pending().length
