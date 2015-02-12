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
      @_club = _fellrace.clubs.findOrAdd(club)
      unless @_club.has("name")
        @_club.fetch()
      @_club_link = new FellRace.Views.ClubLink
        model: @_club
        el: @$el.find(".club")
      @_club_link.render()

  name: (values) =>
    "#{values[0]} #{values[1]}"
