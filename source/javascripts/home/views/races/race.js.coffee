class Home.Views.Race extends Backbone.Marionette.ItemView
  template: 'race_publications/show'
  className: "race"
  # modelEvents:

  events:
    'click a.race_name': "goTo"

  bindings:
    # generally best to bind one element with each declaration:
    # updates are not triggered within a set of bound elements.
    '.race_name': 'name'
    '.distance': 'distance'
    '.climb': "climb"
    '.cat': 'cat'
    '.race_start_time': 'start_time'

    # 'span.race_profile':
    #   observe: ['route_profile', 'route_colour']
    #   update: ($el, vals, model, options) =>
    #     $el.text vals[0]
    #     $el.peity("line", {width: $el.width(), height: $el.height(), fill: vals[1], stroke: vals[1]})

  onRender: =>
    if @model.has "route"
      @polyline = new Home.Views.RacePolyline model: @model
    @stickit()

  goTo: (e) =>
    e.preventDefault()
    Home.selected_race?.trigger "deselect"
    @model.trigger "goTo"
