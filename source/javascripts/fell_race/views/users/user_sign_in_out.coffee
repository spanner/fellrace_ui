class FellRace.Views.UserSignInOut extends FellRace.View
  template: 'users/sign_in_out'
  className: 'controls'

  bindings:
    ".first_name": "first_name"
    ".last_name": "last_name"

  initialize: () ->
    @model = _fr.session
    _fr.vent.on "auth.change", @render
    @render()

  onRender: () =>
    if _fr.session.signedIn()
      @$el.find('.sign_in').hide()
      @$el.find('.sign_out').show()
    else
      @$el.find('.sign_in').show()
      @$el.find('.sign_out').hide()
