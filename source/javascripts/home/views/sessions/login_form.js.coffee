class Home.Views.SessionLoginForm extends Backbone.Marionette.ItemView
  template: 'sessions/login_form'

  events:
    'submit form': 'login'

  bindings:
    "#email": "email"
    "#password": "password"

  initialize: () ->
    @model = Home.session
    Home.vent.on "auth.change", @render

  onRender: () =>
    state = Home.session.getState()
    # this is needed because replacing the view from a marionette region
    # has the side effect of detaching all its events.
    @delegateEvents(@events)
    if state is Home.Models.UserSession.unknownState
      @$el.show()
    else
      @$el.hide()
    @stickit()

  login: (e) =>
    e.preventDefault()
    @$el.find('.error').remove()
    $.ajax
      url: "/users/sign_in.json"
      type: "post"
      data:
        user:
          email: @model.get('email')
          password: @model.get('password')
      success: @succeed
      error: @fail

  succeed: (json) =>
    Home.navigate('/')
    @model.setUser(json)

  fail: (err) =>
    console.log "login error", err
