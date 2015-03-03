class FellRace.Models.Competitor extends FellRace.Model
  urlRoot: =>
    "#{_fellrace.apiUrl()}/competitors"

  initialize: ->
    super
    @build()

  build: =>
    @performances = new FellRace.Collections.Performances @get("performances"), competitor: @
    @entries = new FellRace.Collections.Entries @get("entries")
    @set performances_count: @performances.length
    @on "change:performances", (model, data) =>
      @performances.reset data
    @on "change:entries", (model, data) =>
      @entries.reset data
