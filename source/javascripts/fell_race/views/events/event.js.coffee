class FellRace.Views.Event extends Backbone.Marionette.ItemView
  template: 'events/show'
  className: "event"
  modelEvents:
    'sync': 'resetChanges'

  events:
    'click a.add_race': 'addRace'
    'click a.publish': "publish"
    'click a.preview': "preview"
    'click a.setmap': 'setMap'

  bindings:
    # generally best to bind one element with each declaration:
    # updates are not triggered within a set of bound elements.
    '#name':
      observe: 'name'
      events: ['blur']

    '#event_date':
      observe: 'date'
      events: ['blur']

    '#event_day': 'day'

    '#event_time':
      observe: 'time'
      events: ['blur']

    'span.analytics_id': "analytics_id"

    '#description':
      observe: "description"
      updateMethod: 'html'
      events: ['blur']

    'input#race_show_attachments': "show_attachments"
    'ul.attachments':
      observe: "show_attachments"
      updateView: false
      visible: true

  initialize: ->
    races = @model.races

    _.each ["add", "remove"], (event) =>
      races.on event, @updateRaceCount

  onRender: =>
    @stickit()
    @$el.find('.editable').editable()
    @stickit()

    # @_controls = new FellRace.Views.EventControls(model: @model, el: @$el.find('#eventcontrols'))
    # @_controls.render()

    races_list = new FellRace.Views.RacesList
      collection: @model.races
      el: @$el.find(".races_list")
      parent: @
    races_list.render()

  ## Flash a dom element to show that it has changed

  highlight: ($el, val, options) =>
    $el.signal_confirmation()

  resetChanges: () =>
    # this will mark all editables as unchanged,
    # and could also update a reversion mechanism
    @$el.find('.editable').removeClass('changed')

  ## Add hooks for each of our main collections.
  # The new empty object in each collection will be picked up by the relevant subview.

  addRace: =>
    @model.createRace()

  ## Global methods
  # These will do something to everything, usually by triggering an event on this view and all its subviews.

  error: (args) =>
    $.notify "Error fetching record", args

  updateRaceCount: =>
    hide = true
    unless @model.races.length is 1
      hide = false
    @model.races.each (race) =>
      race.set hide_title: hide

  preview: () =>
    $.notify "start:loader", "Creating event preview. Please hold on."
    $.ajax
      type: "POST"
      url: @model.getPreviewUrl()
      dataType: "text"
      success: () =>
        $.notify "finish:loader"
        _fellrace.navigate "#{@model.publicUrl()}/preview"

  setMap: (e) =>
    e.preventDefault() if e
    map = _fellrace.getMap()
    center = _fellrace.getMap().getCenter()
    data =
      map_lat: center.lat()
      map_lng: center.lng()
      map_zoom: map.getZoom()
      map_style: map.getMapTypeId()
    @model.save data,
      success: =>
        $.notify "success", "Map set as '#{data.map_style}' at the current position"
