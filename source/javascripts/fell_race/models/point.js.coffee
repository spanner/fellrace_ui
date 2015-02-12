class FellRace.Models.Point extends Backbone.Model
  initialize: ->
    @on "moved", @save
    @on "make_checkpoint", @makeCheckpoint
    @on "change:pos", (model) =>
      if @hasChanged("pos")
        @save()

  getLatlng: =>
    new google.maps.LatLng @get("lat"), @get("lng")
