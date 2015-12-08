class FellRace.Models.Entry extends FellRace.Model
  singular_name: 'entry'
  validation:
    terms_accepted:
      acceptance: true
    emergency_contact_name:
      required: true
    emergency_contact_phone:
      required: true

  initialize: ->
    super
    if @collection
      @on "change:paid change:accepted change:cancelled", =>
        @collection.trigger "update_counts"
      @on "change:cancelled", (model,val) =>
        @collection.trigger "model:change:cancelled", model, val

  name: =>
    name = @get("forename")
    name += " #{@get("middlename")}" if @get("middlename")
    "#{name} #{@get("surname")}"

  matchString: =>
    [@get("forename"), @get("surname"), @get("club_name"), @get("category")].join(" ")
