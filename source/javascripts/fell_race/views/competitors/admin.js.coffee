class FellRace.Views.AdminCompetitor extends Backbone.Marionette.ItemView
  template: 'competitors/admin'
  className: "competitor"

  events: 
    "click a.save": "save"

  bindings:
    "a.cancel":
      attributes: [
        name: "href"
        observe: "id"
        onGet: (id) => "/runners/#{id}"
      ]
    ".forename":
      observe: "forename"
      updateModel: false
    ".middlename":
      observe: "middlename"
      updateModel: false
    ".surname":
      observe: "surname"
      updateModel: false

    "#forename": "forename"
    "#surname": "surname"
    "#middlename": "middlename"
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
    "input#club_name": "club_name"

  onRender: =>
    @model.set("postal_country", "GB") unless @model.get("postal_country")
    @stickit()
    @$el.find("input").checkAndTriggerAutoFillEvent()
    @_club_input = @$el.find("input#club_name")
    new FellRace.Views.Picture(model: @model, el: @$el.find(".picture")).render()
    @_club_chooser = new FellRace.Views.ClubChooser
      model: @model
      input: @_club_input
    @_club_chooser.render()
    @_club_chooser.on "chosen", @setClubName

    @_dob_picker = new Pikaday
      field: @$el.find('input#dob')[0]
      format: 'YYYY-MM-D'


  setClubName: =>
    @model.set({"club_name": @_club_input.val()}, {persistChange: true})

  save: =>
    @model.save(club_name: @_club_input.val()).done =>
      _fellrace.navigate "/runners/#{@model.id}"
