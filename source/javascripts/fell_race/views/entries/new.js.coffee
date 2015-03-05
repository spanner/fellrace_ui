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
    @_payment = new FellRace.Models.Payment
      amount: @model.collection.instance.get("online_entry_fee")
    @_competitor.on "change", @setReadiness
    @_payment.on "change", @setReadiness
    @model.on "change", @setReadiness
    Backbone.Validation.bind(@)

  onRender: =>
    @stickit()
    @_edit_competitor_view = new FellRace.Views.EditEntryCompetitor
      model: @_competitor
      el: @$el.find("section.competitor")
    @_edit_payment_view = new FellRace.Views.EditEntryPayment
      model: @_payment
      el: @$el.find("section.payment")
    
    @_edit_competitor_view.render()
    @_edit_payment_view.render()
    
    @_stumbit = @$el.find("a.create")
    @setReadiness()

  setReadiness: () =>
    console.log "setReadiness", @model.isValid(true), @_competitor.isValid(true), @_payment.isValid(true)
    if @isReady()
      @_stumbit.removeClass('unavailable')
    else
      @_stumbit.addClass('unavailable')
  
  isReady: =>
    @model.isValid(true) and @_competitor.isValid(true) and @_payment.isValid(true)

  createEntry: (e) =>
    if @isReady()
      $.notify "flash", "Right you are then."
