class FellRace.Models.PublicCheckpoint extends Backbone.Model
  initialize: ->
    @race_publication = @collection.race_publication
    @race_publication.on "change:selected", =>
      @set selected: @race_publication.selected()
    @set selected: @race_publication.selected()
