class FellRace.Models.Competitor extends FellRace.Model
  singular_name: 'competitor'
  validation:
    forename:
      required: true
    surname:
      required: true
    postal_address_line_1:
      required: true
    postcode:
      required: true
  
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
