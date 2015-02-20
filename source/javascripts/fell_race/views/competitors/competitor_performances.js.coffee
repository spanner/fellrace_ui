class FellRace.Views.CompetitorPerformance extends Backbone.Marionette.ItemView
  template: "competitors/performance"
  tagName: "tr"

  bindings:
    "span.pos": "pos"
    "span.time":
      observe: "time"
      onGet: "secondsToString"
    "a.date":
      observe: "instance_date"
      attributes: [
        {
          name: "href"
          observe: ["instance_name","race_slug"]
          onGet: "instanceUrl"
        }
      ]
    "span.total_competitors":
      observe: "performances_count"
      onGet: "totalCompetitors"

    "a.race_name":
      observe: "race_name"
      attributes: [
        {
          name: "href"
          observe: "race_slug"
          onGet: "raceUrl"
        }
      ]
    "span.race_cat": "race_cat"

    "a.winner":
      observe: "winner_name"
      attributes: [
        {
          name: "href"
          onGet: "winnerUrl"
          observe: ["winner_id","race_slug","instance_name"]
        }
      ]
    "span.winning_time":
      observe: "winning_time"
      onGet: "secondsToString"

  onRender: =>
    @_competitor = @model.competitor
    @stickit()

  raceUrl: (race_slug) =>
    "/runners/#{@_competitor.id}/#{race_slug}"

  instanceUrl: ([name,race_slug]=[]) =>
    "/runners/#{@_competitor.id}/#{race_slug}/#{name}"

  totalCompetitors: (count) =>
    "/#{count}" if count

  fullName: ([first,last]=[]) =>
    "#{first} #{last}" if first and last

  winnerUrl: ([winner_id,race_slug,instance_name]=[]) =>
    "/runners/#{winner_id}/#{race_slug}/#{instance_name}"

  secondsToString: (seconds) =>
    _fellrace.secondsToString seconds

class FellRace.Views.CompetitorPerformancesTable extends Backbone.Marionette.CompositeView
  template: "competitors/performances"
  itemView: FellRace.Views.CompetitorPerformance
  itemViewContainer: 'tbody'
