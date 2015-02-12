class FellRace.Views.PublicationListItem extends Backbone.Marionette.ItemView
  template: 'publications/list_item'
  className: "event"

  bindings:
    ':el':
      observe: "date"
      visible: "visible"
    'span.name': 'name'
    'span.profile':
      observe: 'profile',
      onGet: 'simplifyProfile'
    'span.intro':
      observe: 'clean_description',
      onGet: 'blurb'
    'span.date':
      observe: 'date',
      onGet: 'nextDate'
    'a.event':
      attributes: [
        name: 'href',
        observe: 'slug',
        onGet: 'getUrl'
      ]

  initialize: ({filter:@filter}={}) ->

  onRender: =>
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

  getUrl: (val) =>
    "/events/#{val}"

  visible: (date) =>
    if @filter is "future"
      new Date(date) >= Date.now()
    else
      new Date(date) < Date.now()