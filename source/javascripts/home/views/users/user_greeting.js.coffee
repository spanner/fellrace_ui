class Home.Views.UserGreeting extends Backbone.Marionette.ItemView
  template: 'users/greeting'
  className: 'greeting'
    
  bindings:
    '.first_name': 'first_name'

  initialize: =>
    @model = Home.session.user
    Home.vent.on "auth.change", @render
    @render()

  onRender: () =>
    state = Home.session.getState()
    if state is Home.Models.UserSession.confirmedState or state is Home.Models.UserSession.unconfirmedState
      @$el.show()
      @stickit()
    else
      @$el.hide()
