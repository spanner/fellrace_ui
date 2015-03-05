class FellRace.Views.EditEntryPayment extends Backbone.Marionette.ItemView
  template: 'entries/edit_payment'

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
