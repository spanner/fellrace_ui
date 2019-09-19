class FellRace.Views.EditEntryPayment extends FellRace.View
  template: 'entries/edit_payment'

  events: 
    "click a.create": "prepareTransaction"

  bindings:
    "input#card_number":
      observe: "card_number"
      attributes: [
        name: "class"
        observe: "error_param"
        onGet: (param) -> "error" if param is "card_number"
      ]
    "input#expiry_year":
      observe: "exp_year"
      attributes: [
        name: "class"
        observe: "error_param"
        onGet: (param) -> "error" if param is "exp_year"
      ]
    "input#expiry_month":
      observe: "exp_month"
      attributes: [
        name: "class"
        observe: "error_param"
        onGet: (param) -> "error" if param is "exp_month"
      ]
    "input#cvc":
      observe: "cvc"
      attributes: [
        name: "class"
        observe: "error_param"
        onGet: (param) -> "error" if param is "cvc"
      ]
    "span.card":
      observe: "card_type"
      update: "dimUnlessMatchy"
    "span.error_message": "error_message"

  initialize: () ->
    Backbone.Validation.bind(@)
    @model.on "change:error_message change:error_param", @stopWorking

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
          $thisel.fadeTo(200, 0.1)

  enable: () =>
    @_stumbit.removeClass('unavailable')

  disable: () =>
    @_stumbit.addClass('unavailable')

  stopWorking: =>
    @_stumbit.removeClass "working"

  prepareTransaction: (e) =>
    @model.set(error_param: null, error_message: null)
    unless @_stumbit.hasClass('unavailable')
      @_stumbit.addClass "working"
      Stripe.card.createToken
        number: @model.get('card_number')
        cvc: @model.get('cvc')
        exp_month: @model.get('exp_month')
        exp_year: @model.get('exp_year')
      , @captureStripeToken

  captureStripeToken: (status, response) =>
    if status < 400
      @model.set("stripeToken", response.id)
    else if 400 <= status < 500
      @model.set
        error_param: response.error.param
        error_message: response.error.message
    else
      @model.set(error_message: "Server error, please try again.")
