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
    "#{_fr.apiUrl()}/competitors"

  toJSON: =>
    json = super
    delete json.competitor["picture"] unless @get("image_changed")?
    json

  build: =>
    @performances = new FellRace.Collections.Performances @get("performances"), competitor: @
    @entries = new FellRace.Collections.Entries @get("entries")
    @entries.url = "#{_fr.apiUrl()}/entries"
    @set performances_count: @performances.length

    @on "change:performances", (model, data) =>
      @performances.reset data
    @on "change:entries", (model, data) =>
      @entries.reset data
