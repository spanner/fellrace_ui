class FellRace.Models.PublicCheckpoint extends Backbone.Model
  isPoint: true

  initialize: ->
    @race_publication = @collection.race_publication
    @race_publication.on "change:selected", =>
      @set selected: @race_publication.selected()
    @set selected: @race_publication.selected()

  getLatLng: =>
    if @has("lat") and @has("lng")
      new google.maps.LatLng @get("lat"), @get("lng")
