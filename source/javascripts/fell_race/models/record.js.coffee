class FellRace.Models.Record extends FellRace.Model
  singular_name: 'record'
  defaults:
    holder: null
    year: null
    label: null
    elapsed_time: null

  jsonForPublication: =>
    elapsed_time: @get("elapsed_time")?.toSimplestTime()
    holder: @get("holder")
    label: @get("label")
    year: @get("year")
