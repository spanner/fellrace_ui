class FellRace.Views.EditEntryPayment extends Backbone.Marionette.ItemView
  template: 'entries/edit_payment'

  bindings:
    "input#card_number": "card_number"
    "input#expiry_year": "expiry_year"
    "input#expiry_month": "expiry_month"
    "input#cvc": "cvc"
    "span#amount": 
      observe: "amount"
      onGet: "decimalize"

  initialize: () ->
    Backbone.Validation.bind(@)

  onRender: =>
    @stickit()
    
  decimalize: (value) =>
    value?.toFixed(2)
