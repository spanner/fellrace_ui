class FellRace.Views.NewEntry extends Backbone.Marionette.ItemView
  template: 'entries/new'

  events:
    "click a.create": "createEntry"

  bindings:
    "input#emergency_contact_name": "emergency_contact_name"
    "input#emergency_contact_phone": "emergency_contact_phone"
    "input#terms_accepted": "terms_accepted"

  initialize: ->
    @_competitor = _fellrace.getCurrentCompetitor()
    @model.on "change", @setReadiness
    @_competitor.on "change", @setReadiness
    Backbone.Validation.bind(@)

  onRender: =>
    @stickit()
    @_stumbit = @$el.find('a.create')
    edit_competitor_view = new FellRace.Views.EditEntryCompetitor
      model: @_competitor
      el: @$el.find("section.competitor")
    edit_competitor_view.render()

  setReadiness: () =>
    console.log "setReadiness", @model.isValid(true), @_competitor.isValid(true)
    if @isReady()
      @_stumbit.removeClass("unavailable")
    else
      @_stumbit.addClass("unavailable")
  
  isReady: =>
    @model.isValid(true) and @_competitor.isValid(true)

  createEntry: (e) =>
    if @isReady()
      $.notify "flash", "Right you are then."
