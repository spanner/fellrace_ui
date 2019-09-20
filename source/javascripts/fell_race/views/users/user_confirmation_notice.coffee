class FellRace.Views.UserConfirmationNotice extends FellRace.View
  template: 'users/confirmation_notice'

  events:
    "submit form": "reconfirm"

  bindings:
    ".slug": "desired_slug"
    "#email": "email"
    ".email": "email"
    ".first_name": "first_name"
    ".outcome":
      observe: "desired_slug"
      update: "showDesiredOutcome"
      visible: true

  initialize: () ->
    super()
    @model = _fr.currentUser()
    @_radio.on "auth.change", @render
    @render()

  onRender: () =>
    @stickit()
    state = _fr.session.getState()
    if state is FellRace.Models.UserSession.unconfirmedState
      @$el.show()
    else
      @$el.hide()

  showDesiredOutcome: ($el, value, model, options) =>
    if value? && value isnt ""
      domain = "#{value}.fellrace.org.uk"
      $el.html("Please note that the address <strong>#{domain}</strong> will not be reserved until you finish the confirmation process.")
    else
      $el.hide()

  reconfirm: (e) =>
    e.preventDefault() if e
    @$el.find('input[type="submit"]').disable()
    @model.save {reconfirm: true},
      success: (model, data) =>
        @render()
        _fr.broadcast "success", "Confirmation message sent"

