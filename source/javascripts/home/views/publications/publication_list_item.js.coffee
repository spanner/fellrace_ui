class Home.Views.Publication extends Backbone.Marionette.ItemView
  template: 'publications/list_item'
  className: "event"

  events:
    'click a.marker': 'goTo'

  bindings:
    'span.name': 'name'
    'span.profile':
      observe: 'profile',
      onGet: 'simplifyProfile'
    'span.intro':
      observe: 'description',
      onGet: 'blurb'
    'span.date':
      observe: 'date',
      onGet: 'nextDate'
    'a.event': 
      attributes: [
        name: 'href',
        observe: 'slug',
        onGet: 'subDomain'
      ]

  onRender: =>
    race_publications = @model.get("races")
    @_race_publications = new Home.Collections.RacePublications(race_publications)
    for race_publication in @_race_publications.models
      if race_publication.hasRoute()
        new Home.Views.RacePublicationPolyline model: race_publication
    @stickit()
    if @model.has("profile") and @model.get("profile") != ""
      _.defer @peify

  nextDate: (datestring) =>
    if datestring
      date = new Date(datestring)
      date.simpleDate()

  blurb: (description) =>
    _.str.prune(description, 100)

  simplifyProfile: (profile) =>
    if profile and profile != ""
      elevations = profile.split(',').map (e) -> parseInt(e)
      elevations.join(',')

  peify: () =>
    @$el.find('span.profile').peity "line",
      width: 40
      height: 20

  subDomain: (value) =>
    value ?= @model.get('url').split(/\./)[0]
    "http://#{value}.#{Home.domain()}"

  goTo: (e) =>
    e.preventDefault() if e
    Home.gmap.setOptions
      zoom: @model.get "map_zoom"
      center: @model.getCenter()
