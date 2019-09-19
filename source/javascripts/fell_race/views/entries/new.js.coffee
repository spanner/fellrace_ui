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
    # @_competitor = _fr.getCurrentCompetitor()
    @_instance = @model.collection.instance
    @model.set("cost", @_instance.get("online_entry_fee"))

  onRender: =>
    @stickit()
    @_edit_competitor_view = new FellRace.Views.EditEntryCompetitor
      model: @model.competitor
      el: @$el.find("section.competitor")
    @_edit_competitor_view.render()
    @setReadiness()
    @_competitor.on "change", @setReadiness
    @model.on "change", @setReadiness

  setReadiness: () =>
    if @isReady()
      @_edit_payment_view.enable()
    else
      @_edit_payment_view.disable()
  
  isReady: =>
    @model.isValid(true)

  decimalize: (value) =>
    decimal = value?.toFixed(2)

  calculateCharge: (value) =>
    fee = parseFloat(value)
    merchant_ratio = 0.024
    merchant_fixed = 0.2
    fr_ratio = 0.025
    fr_fixed = 0
    @decimalize(fee * (merchant_ratio + fr_ratio) + merchant_fixed + fr_fixed) + "."




  # performTransaction: (payment, token) =>
  #   @model.set
  #     stripe_token: token
  #     competitor_id: @_competitor.id
  #     user_id: _fr.currentUser().id
  #
  #   @_edit_competitor_view.saveCompetitor =>
  #     @model.save().done () =>
  #       if @model.get("paid")
  #         @_competitor.entries.add @model
  #         @_instance.entries.add @model
  #         _fr.navigate "/races/#{@model.get("race_slug")}/#{@model.get("instance_name")}/my_entry"
  #       else
  #         @_payment.set
  #           error_param: @model.get("error").param
  #           error_message: @model.get("error").message
