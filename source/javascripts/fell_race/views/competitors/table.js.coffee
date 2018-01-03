class FellRace.Views.CompetitorRow extends Backbone.Marionette.ItemView
  template: 'competitors/row'
  className: "competitor"
  tagName: "tr"

  bindings:
    ".name": 
      observe: ["forename", "surname"]
      onGet: "name"
      attributes: [
        {
          name: "href"
          observe: "id"
          onGet: (val) ->
            "/runners/#{val}"
        }
      ]

  onRender: =>
    @stickit()
    if club = @model.get("club")
      @_club = _fr.clubs.findOrAdd(club)
      unless @_club.has("name")
        @_club.fetch()
      @_club_link = new FellRace.Views.ClubLink
        model: @_club
        el: @$el.find(".club")
      @_club_link.render()

  name: (values) =>
    "#{values[0]} #{values[1]}"

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
    