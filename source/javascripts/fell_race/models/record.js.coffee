class FellRace.Models.Record extends FellRace.Model
  defaults:
    holder: null
    year: null
    label: null
    elapsed_time: null

  jsonForPublication: =>
    elapsed_time: _fellrace.secondsToString @get("elapsed_time")
    holder: @get("holder")
    label: @get("label")
    year: @get("year")