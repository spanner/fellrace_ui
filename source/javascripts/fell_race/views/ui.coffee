# The UILayout is an outer wrapper that checks for presence of a signed-in user.
# It doesn't route or bind: those are left to the child view, which will be a
# WorkLayout (if we are signed in) or a SessionLayout (if not). Path changes are
# passed straight through to the child.
#
# In this way we separate status from routing. The status condition is applied first,
# and determines which view does the routing.
#
class FellRace.Views.UILayout extends FellRace.Views.LayoutView
  template: "ui"

  regions:
    gmap: '#gmap'
    content: '#fellrace'
    user_controls: '#user_controls'
    notice: '#notice'
    action: '#action'
    extra: 'section#extra'

  ui:
    content: "#fellrace"

  open_drawer: true

  open_css:
    top: ''
    left: ''

  # This is the outer session-state handler. Our model is the session object.
  # We wait for the session load attempt to conclude (or be short-circuited)
  # then load the right kind of layout view for session status and call setPath on it.
  #
  # If session is still in an indeterminate state, we show a waiter.
  #
  onRender: =>
    @_map_view = new FellRace.Views.Map()
    @showChildView 'gmap', @_map_view

    @_user_controls = new FellRace.Views.UserControls()
    @showChildView 'user_controls', @_user_controls

    @_notifier = new FellRace.Views.Notifier model: _fr._radio, wait: 4000
    @showChildView 'notice', @_notifier

    @listenToToggle()


  ## Routes
  #
  showIndex: =>
    @noExtraView()
    @indexMapView()
    @showView FellRace.Views.IndexView

  showPage: (page_name) =>
    @noExtraView()
    @indexMapView()
    @showView FellRace.Views.Page,
      template: "pages/#{page_name}"

  showRaces: =>
    @showView FellRace.Views.RacePublicationsIndex

  showRace: (slug, path) =>
    model = _fr.race_publications.add(slug: slug)
    @showView FellRace.Views.RacePublicationLayout,
      model: model
      path: path

  showRunner: (path) =>
    @showView FellRace.Views.CompetitorsLayout,
      path: path

  showUser: (path) =>
    @showView FellRace.Views.UsersLayout,
      path: path

  confirmUser: (uid, token) =>
    @showActionView FellRace.Views.SessionConfirmationForm,
      uid: uid
      token: token

  resetPassword: (uid, token) =>
    @showActionView FellRace.Views.SessionPasswordForm,
      uid: uid
      token: token

  showAdminRace: (path) =>
    @showView FellRace.Views.RacesLayout,
      path: path

  showAdminClubs: (path) =>
    @showView FellRace.Views.AdminClubsLayout,
      path: path

  showAdminRunners: (path) =>
    @showView FellRace.Views.AdminCompetitorsLayout,
      path: path


  ## View actions
  #
  showView: (view_class, options={}) =>
    if @_view and @_view instanceof view_class
      @_view.setModel options.model if options.model
      @_view.setPath options.path if options.path
    else
      @_view = new view_class(options)
      @showChildView 'content', @_view

  showActionView: (view_class, options={}) =>
    @_action_view = new view_class(options)
    @showChildView 'action', @_action_view
    @showIndex() unless @_view

  showExtraView: (view, options={}) =>
    @_extra_view = view
    @showChildView 'extra', @_extra_view

  noExtraView: =>
    @getRegion('extra').reset()


  ## Ancient Mike Globals
  #
  showMapRace: (race) =>
    @_map_view.showRace race

  indexMapView: =>
    @_map_view.indexView()

  publicMapView: =>
    @_map_view.publicView()

  adminMapView: =>
    @_map_view.adminView()

  setMapOptions: (opts) =>
    @_map_view?.setOptions(opts)

  moveMapTo: (model, zoom) =>
    @_map_view.moveTo model, zoom

  # Mike's strange old action set has a sort of logic to it.
  # Now moved into the UI and awaiting humane replacement.
  #
  user_actions: =>
    resetPassword: (uid, token) =>
      @actionRegion.show(new FellRace.Views.SessionPasswordForm({uid: uid, token: token}))
    requestReset: =>
      @actionRegion.show(new FellRace.Views.SessionResetForm())
    signOut: =>
      @session.reset()
    signUp: (opts) =>
      @actionRegion.show(new FellRace.Views.UserSignupForm(opts))
    signUpForEvent: =>
      @actionRegion.show(new FellRace.Views.UserSignupFormForRace())
    signIn: (opts) =>
      @actionRegion.show(new FellRace.Views.SessionLoginForm(opts))
    confirm: (uid, token) =>
      @actionRegion.show(new FellRace.Views.SessionConfirmationForm({uid: uid, token: token}))
    reconfirm: =>
      @actionRegion.show(new FellRace.Views.SessionReconfirmationForm())
    requestConfirmation: =>
      @actionRegion.show(new FellRace.Views.ConfirmationRequired())
    signedUp: =>
      _fr.broadcast "success", "User account created"
      @actionRegion.close()
    hideAction: =>
      @actionRegion.close()
    menu: =>
      @actionRegion.show(new FellRace.Views.UserActionMenu())

  listenToToggle: =>
    $("#view_toggle").on "click", =>
      if @ui.content.hasClass("collapsed")
        @ui.content.removeClass("collapsed")
      else
        @ui.content.addClass("collapsed")
        # @user_actions().hideAction()

  offsetX: =>
    if @open_drawer
      -(@ui.content.width() - 10) / 2
    else
      -10 / 2


