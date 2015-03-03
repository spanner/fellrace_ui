class FellRace.Views.CompetitorEntryRow extends Backbone.Marionette.ItemView
  template: "competitors/entry"
  tagName: "tr"

  bindings:
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

  onRender: =>
    @stickit()

  date: (date) =>
    moment(date).format("D MMM YY") if date

class FellRace.Views.CompetitorEntriesTable extends Backbone.Marionette.CompositeView
  template: "competitors/entries"
  itemView: FellRace.Views.CompetitorEntryRow
  itemViewContainer: 'tbody'
