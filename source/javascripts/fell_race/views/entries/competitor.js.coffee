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
    "input#postcode": "postcode"
    "input#email": "email"
    "input#phone": "phone"
    "input#mobile": "mobile"
    "input#club": "club"
    "select#postal_county": 
      observe: "postal_county"
    "select#postal_country": 
      observe: "postal_country"

  initialize: ->
    @setValid()
    @model.updateable()
    @model.on "change", @setValid

  onRender: =>
    # $.getJSON "#{_fellrace.apiUrl()}/clubs", (data) =>
    #   console.debug "#{data.length} clubs", data
    @model.set("postal_country", "GB") unless @model.get("postal_country")
    @stickit()

  setValid: =>
    valid = @model.get("forename") and @model.get("surname") and @model.get("dob") and @model.get("gender") and @model.get("email")
    @model.set valid: valid
