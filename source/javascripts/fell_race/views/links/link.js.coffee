class FellRace.Views.Link extends Backbone.Marionette.ItemView
  template: 'links/link'
  tagName: "li"
  className: "link"
  events:
    'click a.delete': "delete"
    'click a.visit': "goto"
  bindings:
    "span.title": 
      observe: "title"
      events: ['blur']
    'span.url':
      observe: 'url'
      events: ['blur']

  onRender: () =>
    @$el.find('.editable').editable()
    @stickit()

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()
