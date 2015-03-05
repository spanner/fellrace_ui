class FellRace.Views.NewEntry extends Backbone.Marionette.ItemView
  template: 'entries/new'

  bindings:
    "input#emergency_contact_name": "emergency_contact_name"
    "input#emergency_contact_phone": "emergency_contact_phone"
    "input#terms_accepted": "terms_accepted"
    "span#amount": 
      observe: "cost"
      onGet: "decimalize"
    "span#deduction": 
      observe: "cost"
      onGet: "calculateCharge"

  initialize: ->
    @_competitor = _fellrace.getCurrentCompetitor()
    @model.set("cost", @model.collection.instance.get("online_entry_fee"))
    @_payment = new FellRace.Models.Payment
      amount: @model.get("cost")
    @_competitor.on "change", @setReadiness
    @_payment.on "change", @setReadiness
    @model.on "change", @setReadiness
    
    @_payment.on "change:stripeToken", @performTransaction
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
    @setReadiness()

  setReadiness: () =>
    if @isReady()
      @_edit_payment_view.enable()
    else
      @_edit_payment_view.disable()
  
  isReady: =>
    @model.isValid(true) and @_competitor.isValid(true) and @_payment.isValid(true)

  decimalize: (value) =>
    decimal = value?.toFixed(2)

  calculateCharge: (value) =>
    fee = parseFloat(value)
    merchant_ratio = 0.024
    merchant_fixed = 0.2
    fr_ratio = 0.025
    fr_fixed = 0
    @decimalize(fee * (merchant_ratio + fr_ratio) + merchant_fixed + fr_fixed) + "."

  performTransaction: (payment, token) =>
    @set "stripe_token", token
    @save()
