class Home.Models.Instance extends Backbone.Model
  initialize: ->
    @_race = new Home.Models.Race @get("race")

  resultsUrl: =>
    "#{@_race.eventUrl()}/#{@_race.get "slug"}/#{@get "name"}"

  getRaceName: =>
    @_race.get "name"

  getPerformancesCount: =>
    @get "performances_count"

  eventUrl: =>
    @_race.eventUrl()
