class FellRace.Views.NextOrRecentInstance extends Backbone.Marionette.ItemView
  template: "race_publications/next_or_recent_instance"

  bindings:
    "a":
      attributes: [
        name: "href"
        observe: ["race_slug", "name"]
        onGet: "url"
      ]
    ".date":
      observe: "date"
      onGet: "niceDate"
    ".time":
      observe: "time"
      onGet: "niceTime"
    'a.enter_online':
      observe: ['online_entry', 'online_entry_opening', 'online_entry_closing']
      visible: "entryActive"
      visibleFn: "visibleBlock"
    'a.results':
      observe: 'file'
      visible: true

  onRender: =>
    console.log "nori render", @model.attributes
    @stickit()
  
  entryActive: ([atall, start, end]=[]) =>
    console.log "entryActive", arguments
    atall and (start < new Date < end)

  url: ([race_slug, name]=[]) =>
    "/admin/races/#{race_slug}/#{name}"

  niceTime: (time) =>
    time

  niceDate: (date) =>
    moment(date).format("D MMMM YYYY") if date

  visibleBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()
    