class FellRace.Views.UserGreeting extends FellRace.View
  template: 'users/greeting'
  className: 'greeting'
    
  bindings:
    '.first_name': 'first_name'

  initialize: =>
    @model = _fr.currentUser()
    @_radio.on "auth.change", @render
    @render()

  onRender: () =>
    state = _fr.session.getState()
    if state is FellRace.Models.UserSession.confirmedState or state is FellRace.Models.UserSession.unconfirmedState
      @$el.show()
      @stickit()
    else
      @$el.hide()
