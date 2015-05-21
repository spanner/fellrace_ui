class FellRace.Models.Club extends FellRace.Model
  singular_name: 'club'
  defaults:
    entry_count: 0

  urlRoot: ->
    "#{_fellrace.apiUrl()}/clubs"

  build: ->
    @competitors = new FellRace.Collections.Competitors(@get("competitors")||[])
    @on "change:competitors", (model, data) =>
      @competitors.reset data

