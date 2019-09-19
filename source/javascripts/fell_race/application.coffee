FellRace = {}
FellRace.Models = {}
FellRace.Collections = {}
FellRace.Views = {}

root = exports ? this
root.FellRace = FellRace


class FellRace.Application extends Backbone.Marionette.Application
  regions:
    gmap: '#gmap'
    content: '#content'
    main: 'main'
    user_controls: '#user_controls'
    notice: '#notice'
    action: '#action'
    extraContent: 'section#extra'

  months:
    full: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    short: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

  open_drawer: true

  open_css:
    top: ''
    left: ''

  initialize: (opts={}) ->
    root._fr = @
    @original_backbone_sync = Backbone.sync
    Backbone.sync = @sync
    Backbone.Marionette.Renderer.render = @render
    $(document).ajaxSend @sendAuthenticationHeader

    # TODO turn this into a normal function of _fr
    # and stop using the vent anyway
    $.notify = (type, argument) =>
      @vent.trigger(type, argument)

    #TODO this has to go in the UI view and then get less strange
    @actionRegionSetup()

    @_config = new FellRace.Config(options.config)
    @_api_url = @config("api_url")
    @_domain = @config("domain")
    Stripe?.setPublishableKey @config("stripe_publishable_key")

    @session = new FellRace.Models.UserSession()
    @clubs = new FellRace.Collections.Clubs([])
    @categories = new FellRace.Collections.Categories([])
    @categories.fetch()

    #TODO move these to the mapping view: they're used for drawing routes
    @race_publications = new FellRace.Collections.RacePublications([])
    @race_publications.fetch(remove: false)

    #TODO get these out of here
    # they belong in FellRace.Views.IndexView
    # and stop using datey collection classes anyway.
    @future_instances = new FellRace.Collections.PublicFutureInstances([])
    @past_instances = new FellRace.Collections.PublicPastInstances([])
    @future_instances.fetch()
    @past_instances.fetch()


  #TODO minimise application:
  # move regions into a UI view
  # move actions into a session view
  # wait for map to load
  # route with ui functions
  onStart: =>
    @mapView = new FellRace.Views.Map()
    @getRegion('gmap').show @mapView
    @getRegion('user_controls').show new FellRace.Views.UserControls()
    @listenToToggle()

    @getRegion('notice').show new Notifier model: @vent, wait: 4000
    @session.load()

    @router = new FellRace.BaseRouter
    @content = $('#content')
    Backbone.history.start
      pushState: true
      root: '/'


  #TODO move toggle to UI view
  listenToToggle: =>
    $("#view_toggle").on "click", =>
      if @content.hasClass("collapsed")
        @content.removeClass("collapsed")
      else
        @content.addClass("collapsed")
        # @user_actions().hideAction()

  offsetX: =>
    if @open_drawer
      -(@content.width() - 10) / 2
    else
      -10 / 2


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

  closeRight: =>
    @extraContentRegion.close()

  config: (key) =>
    @_config.get(key)

  getCategories: () =>
    @categories



  #TODO Move to UI view and turn these into route handlers instead of click actions.
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
      $.notify "success", "User account created"
      @actionRegion.close()
    hideAction: =>
      @actionRegion.close()
    menu: =>
      @actionRegion.show(new FellRace.Views.UserActionMenu())

  #TODO These will need to be wrapped in a withMap promise handler.
  getMap: =>
    @mapView?.getMap()

  setMapOptions: (opts) =>
    @mapView?.setOptions(opts)

  moveMapTo: (model,zoom) =>
    @mapView.moveTo model, zoom


  # housekeeping can stay here

  currentUser: =>
    @session.user

  userSignedIn: =>
    @session.signedIn()

  userConfirmed: =>
    @session.confirmed()

  authPending: =>
    @session.authPending()

  getCurrentCompetitor: =>
    #TODO: repopulate competitor before entry process begins.
    @currentUser()?.getCompetitor()


  # only these foundations should really be here.

  sync: (method, model, opts) =>
      # unless method is "read"
        # job = opts.job || @announce("Saving")
        # opts.beforeSend = (xhr, settings) ->
        #   settings.xhr = () ->
        #     xhr = new window.XMLHttpRequest()
        #     xhr.upload.addEventListener "progress", (e) ->
        #       job.setProgress e
        #     , false
        #     xhr
        # opts.success = ->
        #   job.setCompleted true
        # opts.error = ->
      @original_backbone_sync method, model, opts

  apiUrl: =>
    @_api_url

  domain: =>
    @_domain

  render: (template, data={}) =>
    if _.isFunction(template)
      template = template()
    if template?
      if FellRace.Templates[template]
        FellRace.Templates[template](data)
      else
        template
    else
      ""

  navigate: (route, {trigger:trigger, replace:replace}={}) =>
    trigger ?= true
    replace ?= false
    @vent.off "login:changed"
    Backbone.history.navigate route,
      trigger:trigger
      replace:replace

  sendAuthenticationHeader: (e, request) =>
    if token = @session?.authToken()
      request.setRequestHeader("Authorization", "Token token=#{token}")


  # TODO: add logging
  # add error-trapping and reporting