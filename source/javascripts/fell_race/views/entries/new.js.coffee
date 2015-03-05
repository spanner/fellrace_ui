class FellRace.Views.NewEntry extends Backbone.Marionette.ItemView
  template: 'entries/new'

  events:
    "click a.create": "createEntry"

  bindings:
    "input.emergency_contact_name": "emergency_contact_name"
    "input.emergency_contact_phone": "emergency_contact_phone"
    "a.create":
      attributes: [
        observe: ["competitor_valid", "payment_ready", "emergency_contact_name", "emergency_contact_phone"]
        name: "class"
        onGet: "readyClass"
      ]

  initialize: ->
    @_competitor = _fellrace.getCurrentCompetitor()
    @_competitor.on "change:valid", (model, value) =>
      @model.set competitor_valid: value

  onRender: =>
    @stickit()
    edit_competitor_view = new FellRace.Views.EditEntryCompetitor
      model: @_competitor
      el: @$el.find("section.competitor")
    edit_competitor_view.render()

  readyClass: ([competitor_valid, contact, contact_no]=[]) ->
    unless competitor_valid and contact and contact_no
      "unavailable"
  
  isReady: =>
    @model.get("competitor_valid") and @model.get("emergency_contact_name") and @model.get("emergency_contact_phone")

  createEntry: (e) =>
    if @isReady()
      $.notify "flash", "well, nearly..."
