class FellRace.Views.CheckpointMapMenu extends Backbone.Marionette.ItemView
  template: "checkpoints/map_menu"
  tagName: "ul"
  className: "map_menu"
  events:
    "click .delete": "delete"
  modelEvents:
    show_menu:  "show"
    hide_menu:  "hide"
    change:     "setOffset"
    destroy:    "remove"

  initialize: =>
    @mapClick = google.maps.event.addListener FellRace.getMap(), "click", @hide
    @mapDrag = google.maps.event.addListener FellRace.getMap(), "drag", @hide

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

  remove: =>
    @$el.remove()
    google.maps.event.removeListener @mapClick
    google.maps.event.removeListener @mapDrag

  setOffset: =>
    if FellRace.getMap().getBounds()
      @offset = @model.getLatlng().canvasOffset(FellRace.getMap())
      @$el.css
        left: @offset.x
        top: @offset.y

  show: =>
    @setOffset()
    @$el.show()

  hide: =>
    @$el.hide()
