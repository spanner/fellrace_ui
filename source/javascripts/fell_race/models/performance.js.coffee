class FellRace.Models.Performance extends FellRace.Model
  singular_name: 'performance'

  getSortName: =>
    @get("competitor_surname") or @get("surname")

  getSortPos: =>
    pos = @get("position")
    pos = 9999999999 if pos is 0
    pos

  getSortTime: =>
    time = @get("time")
    time = 9999999999 if time is 0
    time

  matchString: =>
    [@get("fore"), @get("sur"), @get("cat_name"), @get("club_name")].join(" ")
