class FellRace.Views.NewEntry extends Backbone.Marionette.ItemView
  template: 'entries/new'

  events:
    "click a.create": "createEntry"

  bindings:
    "a.create":
      attributes: [
        observe: ["competitor_valid","payment_ready","emergency_contact","emergency_contact_number"]
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

    #TODO payment_details_view

  readyClass: ([competitor,payment,contact,contact_no]=[]) ->
    unless competitor# and payment and contact and contact_no
      "unavailable"

  isReady: =>
    @model.get("competitor_valid")# and @model.get("payment_ready") and @model.get("emergency_contact") and @model.get("emergency_contact_number")

  createEntry: (e) =>
    if @isReady() and confirm("Create entry and pay.")
      $.notify "flash", "well, nearly..."
