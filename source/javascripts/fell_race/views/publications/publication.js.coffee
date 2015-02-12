class FellRace.Views.Publication extends Backbone.Marionette.ItemView
  template: 'publications/show'
  className: "event"

  events:
    "click .publish": "publish"

  bindings:
    # generally best to bind one element with each declaration:
    # updates are not triggered within a set of bound elements.
    '#name': 'name'

    ".edit":
      observe: "permissions"
      visible: (permissions) =>
        permissions.can_edit
      visibleFn: "visibleBlock"
      attributes: [
        {
          name: "href"
          observe: 'slug'
          onGet: (val) =>
            "/events/#{val}/admin"
        }
      ]

    ".enter":
      observe: ["can_enter","preview"]
      visible: ([can_enter,preview]) ->
        can_enter and not preview
      visibleFn: "visibleBlock"
      attributes: [
        {
          name: "href"
          observe: 'slug'
          onGet: (val) =>
            "/events/#{val}/entry"
        }
      ]

    ".publish":
      observe: "preview"
      updateView: false
      visible: true
      visibleFn: ($el, isVisible, options) =>
        if isVisible
          $el.css display: "inline-block"
        else
          $el.hide()

    '.next':
      observe: 'datestring'
      onGet: (val) =>
        date = new Date(val)
        if date > new Date()
          "Next"
        else
          "Last"

    '#event_date': 'datestring'

    '#event_day': 'day'

    '#description':
      observe: "description"
      updateMethod: 'html'
      attributes: [
        name: "class"
        observe: "description"
        onGet: (val) =>
          "empty" if !val or val is "" or val is "<p><br></p>"
      ]

  onRender: =>
    #TODO only show edit button if user has permission
    @stickit()

    @races = @model.race_publications

    _.each ["add","remove","reset"], (event) =>
      @races.on event, @updateRaceCount

    @updateRaceCount()

    new FellRace.Views.RacePublicationsList(
      collection: @races
      parent: this
      el: @$el.find(".races")
    ).render()

  updateRaceCount: =>
    hide = true
    unless @races.length is 1
      hide = false
    @races.each (race) =>
      race.set
        hide_title: hide

  publish: =>
    $.notify "start:loader", "Publishing event. Please hold on."
    $.ajax
      type: "POST"
      url: @model.getPublishUrl()
      dataType: "text"
      success: () =>
        $.notify "finish:loader"
        _fellrace.navigate "/events/#{@model.get "slug"}", replace: true

  visibleBlock: ($el, isVisible, options) =>
    if isVisible
      $el.css display: "inline-block"
    else
      $el.hide()

  backUp: =>
    _fellrace.navigate "/"
