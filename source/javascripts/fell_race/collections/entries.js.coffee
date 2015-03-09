class FellRace.Collections.Entries extends FellRace.Collection
  model: FellRace.Models.Entry
  comparator: "surname"

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
