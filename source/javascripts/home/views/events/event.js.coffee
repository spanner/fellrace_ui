class Home.Views.Event extends Backbone.Marionette.ItemView
  template: 'events/list_item'
  className: "event"
  tagName: "li"

  events:
    'click a.marker': 'goTo'

  bindings:
    'span.name': 'name'
    'a.event': 
      attributes: [
        name: 'href',
        observe: 'slug',
        onGet: 'eventDomain'
      ]

  onRender: =>
    @stickit()

  eventDomain: (value) =>
    "http://#{value}.#{Home.domain()}"
    
  goTo: (e) =>
    e.preventDefault() if e
    Home.gmap.setOptions
      zoom: @model.get "map_zoom"
      center: @model.getCenter()
