class FellRace.Views.IndexInstance extends Backbone.Marionette.ItemView
  class: "instance"

  race_bindings:
    "a.race_link":
      attributes: [
        name: "href"
        observe: "slug"
        onGet: "raceUrl"
      ]

    "span.race_name": "name"

    'span.profile':
      observe: 'route_profile'
      onGet: 'simplifyProfile'

  onRender: =>
    @_race = @model.race
    @stickit()
    @stickit @_race, @race_bindings
    if @_race.has("route_profile") and @_race.get("route_profile") != ""
      _.defer @peify

  simplifyProfile: (profile) =>
    if profile and profile != ""
      elevations = profile.split(',').map (e) -> parseInt(e)
      elevations.join(',')

  peify: =>
    @$el.find('span.profile').peity "line",
      width: 40
      height: 20

  raceUrl: (slug) =>
    "/races/#{slug}"

  date: (datestring) =>
    date = new Date(datestring).simpleDate()

  instanceUrl: ([name,race]=[]) =>
    if name and race and race.slug
      "/races/#{race.slug}/#{name}"

class FellRace.Views.FutureInstance extends FellRace.Views.IndexInstance
  template: "instances/index/future"

  bindings:
    ".date":
      observe: "date"
      onGet: "date"
    ".entry_count": 'entry_count'

    "a.entries_link":
      observe: ["name","race"]
      onGet: "instanceUrl"

class FellRace.Views.PastInstance extends FellRace.Views.IndexInstance
  template: "instances/index/past"

  bindings:
    ".date":
      observe: "date"
      onGet: "date"
    ".result_count": 'result_count'

    ".results":
      observe: "performances_count"
      visible: true

    "a.results_link":
      attributes: [
        {
          observe: ["name","race"]
          name: "href"
          onGet: "instanceUrl"
        }
      ]

    "span.performances_count": "performances_count"

class FellRace.Views.FutureInstances extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.FutureInstance

  initialize: ->
    @collection = new FellRace.Collections.Instances([])
    @collection.fetch
      data:
        period: "future"
      processData: true

class FellRace.Views.PastInstances extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.PastInstance

  initialize: ->
    @collection = new FellRace.Collections.Instances([])
    @collection.fetch
      data:
        period: "past"
      processData: true
