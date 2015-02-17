class FellRace.Views.CompetitorPerformance extends Backbone.Marionette.ItemView
  template: "competitors/performance"
  tagName: "tr"

  bindings:
    "span.pos": "pos"
    "span.time":
      observe: "time"
      onGet: "time"

  instance_bindings:
    "a.date":
      observe: "date"
      attributes: [
        {
          name: "href"
          observe: "name"
          onGet: "instanceUrl"
        }
      ]
    "span.total_competitors":
      observe: "performances_count"
      onGet: "totalCompetitors"

  winner_bindings:
    "a.winner":
      observe: "name"
      onGet: "fullName"
      attributes: [
        {
          name: "href"
          onGet: "winnerUrl"
          observe: "id"
        }
      ]
    "span.winning_time":
      observe: "time"
      onGet: "time"

  race_bindings:
    "a.race_name":
      observe: "name"
      attributes: [
        {
          name: "href"
          observe: "slug"
          onGet: "raceUrl"
        }
      ]
    "span.race_cat": "cat"

  onRender: =>
    @_instance = @model.instance
    @_race = @_instance.race
    @_competitor = @model.competitor
    @_winner = @_instance.winner

    @stickit()
    @stickit @_instance, @instance_bindings
    @stickit @_winner, @winner_bindings
    @stickit @_race, @race_bindings
    console.log "@_winner",@_winner

  raceUrl: (slug) =>
    "/runners/#{@_competitor.id}/#{slug}"

  instanceUrl: (name) =>
    "/runners/#{@_competitor.id}/#{@_race.get("slug")}/#{name}"

  totalCompetitors: (count) =>
    "/#{count}" if count

  fullName: ([first,last]=[]) =>
    "#{first} #{last}" if first and last

  winnerUrl: (id) =>
    "/runners/#{id}/#{@_race.get("slug")}/#{@_instance.get("name")}"

  time: (seconds) =>
    _fellrace.secondsToString seconds

class FellRace.Views.CompetitorPerformancesTable extends Backbone.Marionette.CompositeView
  template: "competitors/performances"
  itemView: FellRace.Views.CompetitorPerformance
  itemViewContainer: 'tbody'
