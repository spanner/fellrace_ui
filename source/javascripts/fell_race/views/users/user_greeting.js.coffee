class FellRace.Views.UserGreeting extends Backbone.Marionette.ItemView
  template: 'users/greeting'
  className: 'greeting'
    
  bindings:
    '.first_name': 'first_name'

  initialize: =>
    @model = _fr.currentUser()
    _fr.vent.on "auth.change", @render
    @render()

  onRender: () =>
    state = _fr.session.getState()
    if state is FellRace.Models.UserSession.confirmedState or state is FellRace.Models.UserSession.unconfirmedState
      @$el.show()
      @stickit()
    else
      @$el.hide()
