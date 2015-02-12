class FellRace.Collections.Entries extends FellRace.Collection
  model: FellRace.Models.Entry

  paid: =>
    # @where(paid_at: true)

  paidOrAccepted: =>
    # paidOrAccepted

  pending: =>
    # @where
    #   paid: false
    #   accepted: false
