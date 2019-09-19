class FellRace.Collections.Performances extends FellRace.Collection
  model: FellRace.Models.Performance

  nameAsc: (a,b) ->
    a.getSortName().localeCompare(b.getSortName())

  nameDesc: (a,b) ->
    -a.getSortName().localeCompare(b.getSortName())

  posAsc: (m) ->
    m.getSortPos()

  posDesc: (m) ->
    -m.getSortPos()

  clubAsc: (a,b) ->
    a.get("club").localeCompare(b.get("club"))

  clubDesc: (a,b) ->
    -a.get("club").localeCompare(b.get("club"))

  timeAsc: (m) ->
    m.getSortTime()

  timeDesc: (m) ->
    -m.getSortTime()

  catAsc: (a,b) ->
    a.get("cat").localeCompare(b.get("cat"))

  catDesc: (a,b) ->
    -a.get("cat").localeCompare(b.get("cat"))
