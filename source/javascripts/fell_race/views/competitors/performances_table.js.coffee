class FellRace.Views.CompetitorPerformanceRow extends Backbone.Marionette.ItemView
  template: "competitors/performance"
  tagName: "tr"

  bindings:
    "span.pos": "pos"
    "span.time":
      observe: "time"
      onGet: "secondsToString"
    "span.date":
      observe: "instance_date"
      onGet: "date"
    "span.total_competitors":
      observe: "performances_count"
      onGet: "totalCompetitors"

    "a.race_name":
      observe: "race_name"
      attributes: [
        name: "href"
        observe: ["competitor_id","race_slug","instance_name"]
        onGet: "url"
      ]

    "a.winner":
      observe: "winner_name"
      attributes: [
        name: "href"
        observe: ["winner_id","race_slug","instance_name"]
        onGet: "url"
      ]

    "span.winning_time":
      observe: "winning_time"
      onGet: "secondsToString"

  onRender: =>
    @stickit()

  url: ([competitor_id,race_slug,name]=[]) =>
    "/runners/#{competitor_id}/#{race_slug}/#{name}"

  totalCompetitors: (count) =>
    "/#{count}" if count

  fullName: ([first,last]=[]) =>
    "#{first} #{last}" if first and last

  secondsToString: (seconds) =>
    _fellrace.secondsToString seconds

  date: (date) =>
    moment(date).format("D MMM YY") if date

class FellRace.Views.CompetitorPerformancesTable extends Backbone.Marionette.CompositeView
  template: "competitors/performances"
  itemView: FellRace.Views.CompetitorPerformanceRow
  itemViewContainer: 'tbody'
