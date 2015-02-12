class FellRace.Views.EventsListItem extends Backbone.Marionette.ItemView
  template: "events/list_item"
  tagName: "li"
  bindings:
    'a.name':
      observe: "name"
      attributes: [
        {
          name: "href"
          onGet: "url"
          observe: "slug"
        }
      ]
    'a.slug':
      observe: "slug"
      onGet: (slug) =>
        "#{slug}.#{_fellrace.domain()}"
      attributes: [
        {
          name: "href"
          observe: "slug"
          onGet: (slug) =>
            "/events/#{slug}"
        }
      ]

  onRender: =>
    @stickit()

  url: (slug) =>
    "/events/#{slug}/admin"
