class FellRace.Views.PublishedLink extends Backbone.Marionette.ItemView
  template: 'links/published/list_item'
  tagName: "li"
  className: "link"

  bindings:
    "a.title":
      observe: ["title", "url"]
      onGet: (vals) =>
        if vals[0] and vals[0] isnt "" then vals[0] else vals[1]
      attributes: [
        {
          name: "href"
          observe: "url"
          onGet: (url) =>
            "http://#{url}"
        }
      ]

  events:
    "click a": "openTab"

  onRender: () =>
    @stickit()

  openTab: (e) =>
    e.preventDefault() if e
    window.open "http://#{@model.get("url")}"
