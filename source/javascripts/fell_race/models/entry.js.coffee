class FellRace.Models.Entry extends FellRace.Model
  initialize: ->
    super
    if @collection
      @on "change:paid change:accepted", =>
        @collection.trigger "update_counts"
