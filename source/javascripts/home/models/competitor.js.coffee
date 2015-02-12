class Home.Models.Competitor extends Backbone.Model
  urlRoot: "/api/competitors"

  getName: =>
    "#{@get "forename"} #{@get "surname"}"

  claim: =>
    $.getJSON("#{@url()}/claim").done(@afterClaim)#.fail()

  afterClaim: (data) =>
    @set data

  getClub: =>
    @_club

  getPerformances: =>
    @_performances
