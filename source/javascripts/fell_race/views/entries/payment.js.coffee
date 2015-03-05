class FellRace.Views.EditEntryPayment extends Backbone.Marionette.ItemView
  template: 'entries/edit_payment'

  events: 
    "click a.create": "prepareTransaction"

  bindings:
    "input#card_number": "card_number"
    "input#expiry_year": "expiry_year"
    "input#expiry_month": "expiry_month"
    "input#cvc": "cvc"
    "span.card":
      observe: "card_type"
      update: "dimUnlessMatchy"

  initialize: () ->
    Backbone.Validation.bind(@)

  onRender: =>
    @stickit()
    @_stumbit = @$el.find("a.create")

  dimUnlessMatchy: ($el, val, model, options) =>
    if !val
      $el.fadeTo(200, 0.6)
    else
      $el.each (i, thisel) =>
        $thisel = $(thisel)
        if $thisel.hasClass(val)
          $thisel.fadeTo(200, 1.0)
        else
          $thisel.fadeTo(200, 0.2)

  enable: () =>
    @_stumbit.removeClass('unavailable')

  disable: () =>
    @_stumbit.addClass('unavailable')

  prepareTransaction: (e) =>
    unless @_stumbit.hasClass('unavailable')
      @_stumbit.addClass "working"
      
      Stripe.card.createToken
        number: @model.get('card_number')
        cvc: @model.get('cvc')
        exp_month: @model.get('expiry_month')
        exp_year: @model.get('expiry_year')
      , @captureStripeToken

  captureStripeToken: (status, response) =>
    if status < 400
      @model.set("stripeToken", response.id)
    else if 400 <= status < 500
      $.notify "error", "something wrong with your card details"
    else
      $.notify "error", "Stripe server error"
