class FellRace.Views.IndexInstance extends FellRace.View
  className: "instance"

  bindings:
    ".date":
      observe: "date"
      onGet: "date"

    "a.race_link":
      attributes: [
        name: "href"
        observe: "race_slug"
        onGet: "raceUrl"
      ]
    "span.race_name": "race_name"

    'span.profile':
      observe: 'route_profile'
      onGet: 'simplifyProfile'

  onRender: =>
    _.extend(@bindings, @extra_bindings) if @extra_bindings
    @stickit()
    console.log @model
    if @model.has("route_profile") and @model.get("route_profile") != ""
      _.defer @peify

  simplifyProfile: (profile) =>
    if profile and profile != ""
      elevations = profile.split(',').map (e) -> parseInt(e)
      elevations.join(',')

  peify: =>
    @$el.find('span.profile').peity "line",
      fill: "#e2e1dd"
      stroke: "#d6d6d4"
      width: 40
      height: 24

  raceUrl: (slug) =>
    "/races/#{slug}"

  date: (datestring) =>
    date = new Date(datestring).simpleDate()

  instanceUrl: ([name,race_slug]=[]) =>
    "/races/#{race_slug}/#{name}" if name and race_slug


class FellRace.Views.FutureIndexInstance extends FellRace.Views.IndexInstance
  template: "instances/index/future"

  extra_bindings:
    ".entry_count": 'entry_count'
    "a.online_entries":
      observe: "online_entry_active"
      visible: true
      attributes: [
        observe: ["name","race_slug"]
        name: "href"
        onGet: "instanceUrl"
      ]


class FellRace.Views.PastIndexInstance extends FellRace.Views.IndexInstance
  template: "instances/index/past"

  extra_bindings:
    ".results":
      observe: "performances_count"
      visible: true
    "a.results_link":
      observe: "has_results"
      visible: true
      attributes: [
        observe: ["name","race_slug"]
        name: "href"
        onGet: "instanceUrl"
      ]
    "span.performances_count": "performances_count"

class FellRace.Views.FutureIndexInstances extends FellRace.CollectionView
  itemView: FellRace.Views.FutureIndexInstance

class FellRace.Views.PastIndexInstances extends FellRace.CollectionView
  itemView: FellRace.Views.PastIndexInstance
