class FellRace.Views.CompetitorEntryRow extends FellRace.View
  template: "competitors/entry"
  tagName: "tr"

  events:
    "click a.cancel": "withdraw"

  bindings:
    ":el":
      classes:
        cancelled: "cancelled"
    "span.date":
      observe: "instance_date"
      onGet: "date"
    "a.race":
      observe: "race_name"
      attributes: [
        observe: ["race_slug","instance_name"]
        name: "href"
        onGet: ([race_slug,instance_name]=[]) ->
          "/races/#{race_slug}/#{instance_name}"
      ]
    "a.cancel":
      observe: ["permissions","cancelled"]
      visible: true
      onGet: ([permissions,cancelled]) ->
        permissions?.can_cancel and !cancelled
    "span.cancelled":
      observe: "cancelled"
      visible: true

  onRender: =>
    @stickit()

  date: (date) =>
    moment(date).format("D MMM YY") if date

  currency: (amount=0) ->
    (amount / 100.0).toFixed(2)

  withdraw: =>
    if confirm "Cancel entry for #{@model.get("race_name")} #{@model.get("instance_name")}?"
      @model.set {cancelled:true}, persistChange: true

class FellRace.Views.CompetitorEntriesTable extends FellRace.CollectionView
  template: "competitors/entries"
  childView: FellRace.Views.CompetitorEntryRow
  itemViewContainer: 'tbody'

  bindings:
    ":el":
      observe: "entries"
      visible: "any"

  onRender: =>
    @stickit()

  any: (array=[]) -> array.length > 0
