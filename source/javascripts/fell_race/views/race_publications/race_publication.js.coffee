class FellRace.Views.RacePublication extends Backbone.Marionette.ItemView
  template: 'race_publications/show'
  className: "race"

  events:
    'click .opener': 'toggle'
    'click a.social': 'openTab'

  bindings:
    # generally best to bind one element with each declaration:
    # updates are not triggered within a set of bound elements.
    '.race_title':
      observe: 'hide_title'
      updateView: false
      visible: (val) ->
        !val
    '.name': 'name'
    '.distance': 'distance'
    '.description':
      observe: 'description'
      updateMethod: 'html'
    '.climb': "climb"
    '.cat': 'cat'
    '.race_start_time': 'start_time'

    # external event ids
    'a.fb':
      observe: 'fb_event_id'
      updateView: false
      visible: true
      visibleFn: "visibleBlock"
      attributes: [
        {
          name: "href"
          observe: "fb_event_id"
          onGet: (val) =>
            "https://www.facebook.com/events/#{val}" if val
        }
      ]

    'a.twit':
      observe: 'twitter_id'
      updateView: false
      visible: true
      visibleFn: "visibleBlock"
      attributes: [
        {
          name: "href"
          observe: "twitter_id"
          onGet: (val) =>
            "http://www.twitter.com/#{val}" if val
        }
      ]
    'a.fra':
      observe: 'fra_id'
      updateView: false
      visible: true
      visibleFn: "visibleBlock"
      attributes: [
        {
          name: "href"
          observe: "fra_id"
          onGet: (val) =>
            "http://www.fellrunner.org.uk/races.php?id=#{val}" if val
        }
      ]

    'a.shr':
      observe: 'shr_id'
      updateView: false
      visible: true
      visibleFn: "visibleBlock"
      attributes: [
        {
          name: "href"
          observe: "shr_id"
          onGet: (val) =>
            "http://www.scottishhillracing.co.uk/RaceDetails.aspx?RaceID=RA-#{val}" if val
        }
      ]

    'span.age_limit': 
      observe: "age_limit"

    '.route_elevation': "route_elevation"

    'span.race_profile':
      observe: 'route_profile'
      update: "peify"

    '.race_organiser':
      observe: ["organiser_email", 'organiser_phone', 'organiser_name', 'organiser_address']
      updateView: false
      visible: (vals) =>
        vals[0] isnt "" or vals[1] isnt "" or vals[2] isnt "" or vals[3] isnt ""

    '.organiser_name':
      observe: "organiser_name"
      onGet: (val) =>
        if !val or val is ""
          val = "@"
        val
      attributes: [
        {
          name: "href"
          observe: "organiser_email"
          onGet: (val) =>
            if val
              "mailto:#{val}"
            else
              null
        }
      ]
    '.organiser_phone': "organiser_phone"
    '.organiser_address':
      observe: "organiser_address"
      updateMethod: "html"
      onSet: (val) ->
        val = null if /(\<div\>\<br\>\<\/div\>|\<br\>)/.test(val)
        val

    '.requirements':
      observe: "requirements"
      updateMethod: "html"

    '.race_requirements':
      observe: "requirements"
      visible: true

    '.attachments':
      observe: "attachments"
      visible: "hasAny"

    '.links':
      observe: ["links","fra_id","shr_id","fb_event_id","twitter_id"]
      visible: (vals) =>
        vals[0].length > 0 or vals[1] or vals[2] or vals[3] or vals[4]

    '.instances':
      observe: "instances"
      visible: "hasAny"

    '.records':
      observe: "records"
      visible: "hasAny"

    '.checkpoints':
      observe: "checkpoints"
      visible: "hasAny"

    'a.opener':
      attributes: [
        {
          observe: "selected"
          name: "class"
          onGet: (selected) =>
            "open" if selected
        }
      ]

    ':el':
      attributes: [
        {
          observe: "selected"
          name: "class"
          onGet: (selected) =>
            "small" unless selected
        }
      ]

  toggle: =>
    @model.trigger "toggle_select"

  quickSlide: ($el, isVisible, options) =>
    if (isVisible) then $el.slideDown('fast') else $el.slideUp('fast')

  onRender: =>
    @stickit()
    new FellRace.Views.PublishedAttachmentsList(collection: @model.attachments, el: @$el.find("ul.attachments")).render()
    new FellRace.Views.PublishedLinksList(collection: @model.links, el: @$el.find("ul.links")).render()
    new FellRace.Views.PublishedCheckpointsList(collection: @model.checkpoints, el: @$el.find("ul.checkpoints")).render()
    new FellRace.Views.PublishedRecordsList(collection: @model.records, el: @$el.find("ul.records")).render()
    new FellRace.Views.PublishedInstancesList(collection: @model.instances, el: @$el.find("ul.instances")).render()

  showPresence: (e) =>
    el = $(e.currentTarget)
    val = _.str.trim(el.text())
    if val isnt ""
      el.addClass('present')
    else
      el.removeClass('present')

  getRouteDistance: =>
    @model.getRouteDistance()

  visibleBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()

  peify: ($el, value, model, options) =>
    $(window).on "resize", =>
      @old_peify()
    checkExist = setInterval(() =>
      if $el.length
        clearInterval(checkExist)
        $el.text value
        $el.peity("line")
        @old_peify()
    , 100)

  old_peify: () =>
    @$el.find('span.race_profile').peity "line",
      fill: "#e2e1dd"
      stroke: "#d6d6d4"
      width: @$el.width()
      height: 100

  hasAny: (array) =>
    array.length > 0

  openTab: (e) =>
    e.preventDefault() if e
    window.open e.currentTarget.href

class FellRace.Views.RacePublicationsList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.RacePublication
