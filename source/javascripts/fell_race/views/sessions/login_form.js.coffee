class FellRace.Views.SessionLoginForm extends Backbone.Marionette.ItemView
  template: 'sessions/login_form'

  events:
    'submit form': 'login'
    'click a.forgotten': 'forgotten'
    'click a.reconfirm': 'reconfirm'
    'click a.sign_up': 'signUp'

  bindings:
    "#email": "email"
    "#password": "password"

  initialize: (opts={}) ->
    @opts = opts
    @model = _fellrace.session
    _fellrace.vent.on "auth.change", @render

  onRender: () =>
    state = _fellrace.session.getState()
    # this is needed because replacing the view from a marionette region
    # has the side effect of detaching all its events.
    @delegateEvents(@events)
    # if state is FellRace.Models.UserSession.unknownState
    #   @$el.show()
    # else
    #   @$el.hide()
    @stickit()

  login: (e) =>
    e.preventDefault() if e
    @$el.find('.error').remove()
    $.ajax
      url: "#{_fellrace.config("api_url")}/users/sign_in.json"
      type: "post"
      data:
        user:
          email: @model.get('email')
          password: @model.get('password')
      success: @succeed
      error: @fail

  succeed: (json) =>
    _fellrace.actionRegion.close()
    $.notify "success", "Sign in successful"
    @model.setUser(json)

  fail: (err) =>
    console.log "login error", err

  forgotten: =>
    _fellrace.user_actions().requestReset()

  reconfirm: =>
    _fellrace.user_actions().reconfirm()

  signUp: =>
    _fellrace.user_actions().signUp(@opts)

  submit: =>
    @login()
