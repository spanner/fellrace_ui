class FellRace.Views.SessionLoginForm extends FellRace.View
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
    @model = _fr.session
    _fr.vent.on "auth.change", @render

  onRender: () =>
    state = _fr.session.getState()
    # this is needed because replacing the view from a marionette region
    # has the side effect of detaching all its events.
    @delegateEvents(@events)
    # if state is FellRace.Models.UserSession.unknownState
    #   @$el.show()
    # else
    #   @$el.hide()
    if @opts.heading
      @$el.find('h3').text(@opts.heading)
    @stickit()
    @$el.find("input").checkAndTriggerAutoFillEvent()

  login: (e) =>
    e.preventDefault() if e
    @$el.find('.error').remove()
    $.ajax
      url: "#{_fr.config("api_url")}/users/sign_in.json"
      type: "post"
      data:
        user:
          email: @model.get('email')
          password: @model.get('password')
      success: @succeed
      error: @fail

  succeed: (json) =>
    _fr.actionRegion.close()
    _fr.broadcast "success", "Sign in successful"
    _fr.navigate(@opts.destination_url, replace:true) if @opts.destination_url
    @model.setUser(json)

  fail: (err) =>
    console.log "login error", err

  forgotten: =>
    _fr.user_actions().requestReset()

  reconfirm: =>
    _fr.user_actions().reconfirm()

  signUp: =>
    _fr.user_actions().signUp(@opts)

  submit: =>
    @login()
