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
    "select#postal_county": "postal_county"
    "select#postal_country": "postal_country"
    "input#club_name": 
      observe: "club_name"
      updateModel: false

  initialize: ->
    @model.updateable()
    Backbone.Validation.bind(@)

  onRender: =>
    @model.set("postal_country", "GB") unless @model.get("postal_country")
    #TODO ensure email present on competitor as well as user
    @stickit()
    @$el.find("input").checkAndTriggerAutoFillEvent()
    @_club_input = @$el.find("input#club_name")
    @_club_chooser = new FellRace.Views.ClubChooser
      model: @model
      input: @_club_input
    @_club_chooser.render()
    @_club_chooser.on "chosen", @setClubName
    #
    # @_club_input.on "blur", (e) =>
    #   console.log $(e.currentTarget).val()

    @_dob_picker = new Pikaday
      field: @$el.find('input#dob')[0]
      format: 'YYYY-MM-D'


  setClubName: =>
    @model.set({"club_name": @$el.find("input#club_name").val()}, {persistChange: true})
