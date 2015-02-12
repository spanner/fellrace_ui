class FellRace.Views.CompetitorsTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.CompetitorRow
  itemViewContainer: ".competitors"
  template: "competitors/table"
  id: "competitors"

  events:
    "click a.search": "search"
    "keypress": "keypress"

  bindings:
    "span.forename": "forename"
    "span.surname": "surname"
    "span.club": "club"

  onRender: =>
    @$el.find('.editable').editable()
    @stickit()

  search: (e) =>
    e.preventDefault() if e
    forename = @model.get("forename") || ""
    surname = @model.get("surname") || ""
    club = @model.get("club") || ""
    @searching()
    $.getJSON "/api/competitors/search?forename=#{forename}&surname=#{surname}&club=#{club}", (response) =>
      @collection.set response
      @doneSearching()

  keypress: (e) =>
    code = e.keyCode || e.which
    if code is 13
      e.preventDefault()
      @search()

  searching: =>
    @$el.find("a.search").addClass "waiting"

  doneSearching: =>
    @$el.find("a.search").removeClass "waiting"
    