class FellRace.Models.Competitor extends Backbone.Model
  urlRoot: "/api/competitors"

  initialize: ->
    @build()

  build: =>
    @buildClub()
    @buildPerformances()

  buildClub: =>
    @club = new FellRace.Models.Club(@get("club"))
    @on "change:club", (model, club) =>
      @club.clear()
      @club.set club

  buildPerformances: =>
    @performances = new FellRace.Collections.Performances @get("performances"), competitor: @
    @set performances_count: @performances.length
    @on "change:performances", (model, performances) =>
      @performances.reset performances
      @set performances_count: @performances.length

  getName: =>
    "#{@get "forename"} #{@get "surname"}"

  getClubName: =>
    @club.get("name")

  editable: =>
    if @has("permissions")
      @get("permissions").can_edit
