class FellRace.Models.Club extends FellRace.Model
  urlRoot: ->
    "#{_fellrace.apiUrl()}/clubs"

  initialize: ->
    @competitors = new FellRace.Collections.Competitors(@get("competitors")||[])
    @on "change:competitors", (model, data) =>
      @competitors.reset data
