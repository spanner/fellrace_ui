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
      @on "change:paid change:accepted", =>
        @collection.trigger "update_counts"
