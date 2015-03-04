class FellRace.Views.EditEntryCompetitor extends Backbone.Marionette.ItemView
  template: 'entries/edit_competitor'

  bindings:
    "input#forename": "forename"
    "input#middlename": "middlename"
    "input#surname": "surname"
    "input[name='gender']": "gender"
    "input#dob": "dob"
    "input#postal_address_line_1": "postal_address_line_1"
    "input#postal_address_line_2": "postal_address_line_2"
    "input#postal_town": "postal_town"
    "input#postal_county": "postal_county"
    "input#postcode": "postcode"
    "input#postal_country": "postal_country"
    "input#email": "email"
    "input#phone": "phone"
    "input#mobile": "mobile"
    "input#club": "club"

  initialize: ->
    @setValid()
    @model.updateable()
    @model.on "change", @setValid

  onRender: =>
    # $.getJSON "#{_fellrace.apiUrl()}/clubs", (data) =>
    #   console.debug "#{data.length} clubs", data
    @stickit()

  setValid: =>
    valid = false
    c = @model
    if c.get("forename") and c.get("surname") and c.get("dob") and c.get("gender") and c.get("email")
      valid = true
    @model.set valid: valid
