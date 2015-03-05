# The session holds our current authentication state as a user object.
# It is a simple state machine with these states:
# * unknown: not authenticated
# * pending: pending authentication
# * unconfirmed: authenticated but unconfirmed
# * confirmed: authenticated and confirmed
# * failed: authentication attempt failed
#
# State changes are signalled with Home.vent events in the auth. namespace. 
# At the moment we just trigger 'auth.changed', which causes re-renders in user-specific views.
#
class FellRace.Models.UserSession extends Backbone.Model
  @unknownState: 'Unknown'
  @pendingState: 'Authentication in progress'
  @unconfirmedState: 'User account is not confirmed'
  @confirmedState: 'User account is confirmed'
  @failedState: 'User credentials are not correct'

  defaults:
    state: @unknownState
    email: ""
    password: ""
    password_confirmation: ""
  
  # The session...
  #
  initialize: () ->
    @user = new FellRace.Models.User()
    @on "change:state", @changedState

  ## Persistence
  #
  # The session stores a cookie containing its user's uid and (safely hashed) auth_token.
  # On initialization we request user data from the back end; if the uid/token are valid,
  # this call will return a packet of user data that we can use to populate the session 
  # user object. The uid/token don't need to be passed explicitly: they are given in the 
  # request header in the usual way.
  #
  # Calling load automatically on initialization seems to be too early for the ajax header
  # modification, so until I fix that we're calling it manually later on in `FellRace.start`.
  #
  load: () =>
    if @authToken()
      @set state: FellRace.Models.UserSession.pendingState
      $.getJSON("#{_fellrace.apiUrl()}/users/me").done(@setUser) #.fail(@unsetCookie)

  reset: () =>
    @user.clear()
    @_token = null
    @setState()
    @unsetCookie()

  # setUser is called from various form views to supply user data that they
  # have received from the server, eg on registration or signing in.
  #
  setUser: (data) =>
    @user.set(data)
    @_token = null
    @setState()
    @setCookie()

  signedIn: () =>
    @user and not @user.isNew()

  # All our user-specific views call getState on render.
  #
  getState: () =>
    @get('state')

  # And nearly all of them re-render when they see an 'auth.change' event,
  # which is usually triggered by setting state here.
  #
  setState: () =>
    if !@user or !@user.get('uid')
      @set "state", FellRace.Models.UserSession.unknownState
    else if @user.get('confirmed')
      @set "state", FellRace.Models.UserSession.confirmedState
    else
      @set "state", FellRace.Models.UserSession.unconfirmedState

  changedState: (model, value, options) =>
    _fellrace.vent.trigger('auth.change', model, value)

  authPending: =>
    @getState() is FellRace.Models.UserSession.pendingState

  ## API authentication
  #
  # This is called from FellRace.setAuthenticationHeader to add credentials to every API call.
  # Usually the uid and token come from the signed in user but on initialisation we don't 
  # have that user yet: in that case we try the cookie token instead.
  #
  authToken: () =>
    if @signedIn()
      @user.get('uid') + @user.get('authentication_token')
    else if stored_token = @getCookie()
      stored_token

  # All our auth has to span subdomains.
  #
  cookieDomain: () =>
    ".#{_fellrace.domain()}"

  getCookie: () =>
    $.cookie('fellrace_blah')

  setCookie: () =>
    if token = @authToken()
      $.cookie 'fellrace_blah', token,
        domain: @cookieDomain()
        path: "/"
        expires: 7
      _fellrace.vent.trigger "login:changed"

  unsetCookie: () =>
    $.removeCookie 'fellrace_blah',
      domain: @cookieDomain()
      path: "/"
    _fellrace.vent.trigger "login:changed"