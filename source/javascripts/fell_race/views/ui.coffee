class FellRace.Views.Ui extends Fellrace.View
  
  regions:
    gmap: '#gmap'
    content: '#content'
    main: 'main'
    user_controls: '#user_controls'
    notice: '#notice'
    action: '#action'
    extraContent: 'section#extra'
  
  
  #TODO this has to go in the UI view and then get less strange
  @actionRegionSetup()
  
  
  #TODO 1. move to UI view
  # 2. we can't route this so it does have to be event-based
  # 3. but why isn't it encapsulated in a View? ugh.
  #
  actionRegionSetup: =>
    action_region = @getRegion('action')
    action_region
      .on "show", (view) ->
        @$el.show()
        @$el.find("a.close, a.hide, a.cancel").on "click", =>
          @trigger "close"
      .on "hide", (view) ->
        @$el.hide()
      .on "close", (view) ->
        @$el.hide()
    $(document).keyup (e) =>
      code = e.keyCode || e.which
      if code is 27
        action_region.close()
      else if code is 13
        action_region.currentView.trigger("submit") if action_region.currentView
        
  #TODO minimise application:
  # move regions into a UI view
  # move actions into a session view
  # wait for map to load
  # route with ui functions      
  @getRegion('gmap').show @mapView
  @getRegion('user_controls').show new FellRace.Views.UserControls()
  @listenToToggle()

  @getRegion('notice').show new Notifier model: @vent, wait: 4000
  
  
  #TODO move toggle to UI view
  listenToToggle: =>
    $("#view_toggle").on "click", =>
      if @content.hasClass("collapsed")
        @content.removeClass("collapsed")
      else
        @content.addClass("collapsed")
        # @user_actions().hideAction()
  
  #TODO move route handlers to UI view
  showRace: (race) =>
    @mapView.showRace race

  indexMapView: =>
    @mapView.indexView()

  publicMapView: =>
    @mapView.publicView()

  adminMapView: =>
    @mapView.adminView()

  toPublicOrHome: =>
    _fr.navigate Backbone.history.fragment.match(/admin(.+)/)?[1] || "/"
  
  #TODO Move to UI view and turn these into route handlers instead of click actions.
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
      $.notify "success", "User account created"
      @actionRegion.close()
    hideAction: =>
      @actionRegion.close()
    menu: =>
      @actionRegion.show(new FellRace.Views.UserActionMenu())
  