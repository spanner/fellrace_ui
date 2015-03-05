class FellRace.Views.NextOrRecentInstance extends Backbone.Marionette.ItemView
  template: "race_publications/next_or_recent_instance"

  bindings:
    "a.date":
      observe: "date"
      onGet: "niceDate"
      attributes: [
        observe: ["race_slug", "name"]
        name: "href"
        onGet: "url"
      ]
    ".time":
      observe: "time"
      onGet: "niceTime"
    'a.enter_online':
      observe: 'online_entry_active'
      visible: true
      visibleFn: "visibleBlock"
      attributes: [
        name: "href"
        observe: ["race_slug", "name"]
        onGet: "enterOnlineHref"
      ]
    'a.enter_postal':
      observe: 'postal_entry_active'
      visible: true
      visibleFn: "visibleBlock"
      attributes: [
        name: "href"
        observe: "entry_form"
        onGet: "entryFormUrl"
      ,
        name: "class"
        observe: "entry_form_type"
      ]
    'span.both':
      observe: ["online_entry_active", "postal_entry_active"]
      visible: ([a,b]=[]) -> a and b
    'span.online_entry_fee':
      observe: 'online_entry_fee'
      onGet: 'decimalize'
    'span.postal_entry_fee':
      observe: 'postal_entry_fee'
      onGet: 'decimalize'
    'span.eod_fee': 
      observe: 'eod_fee'
      onGet: 'decimalize'
    'span.eod':
      observe: "eod"
      visible: true
    'span.no_eod':
      observe: "eod"
      visible: "untrue"
    'a.results':
      observe: 'file'
      visible: true

  onRender: =>
    @stickit()
  
  entryActive: ([atall, start, end]=[]) =>
    atall and (start < new Date < end)

  entryActiveAndFormAvailable: ([atall, start, end, url]=[]) =>
    atall and url and (start < new Date < end)

  url: ([race_slug, name]=[]) =>
    "/races/#{race_slug}/#{name}"

  enterOnlineHref: ([race_slug, name]=[]) =>
    "/races/#{race_slug}/#{name}/enter"

  niceTime: (time) =>
    time

  niceDate: (date) =>
    moment(date).format("D MMMM YYYY") if date

  visibleBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()
  
  untrue: (value) =>
    not value
    
  decimalize: (value) =>
    value?.toFixed(2)

  entryFormUrl: (url) =>
    if url
      if url.match(/^\//)
        "#{_fellrace.apiUrl()}#{url}"
      else
        url
