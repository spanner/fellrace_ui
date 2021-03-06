FellRace = {}
FellRace.Models = {}
FellRace.Collections = {}
FellRace.Views = {}

root = exports ? this
root.FellRace = FellRace


class FellRace.Application extends Backbone.Marionette.Application
  regions:
    gmapRegion: '#gmap'
    contentRegion: '#content'
    mainRegion: 'main'
    user_controlsRegion: '#user_controls'
    noticeRegion: '#notice'
    actionRegion: '#action'
    extraContentRegion: 'section#extra'

  months:
    full: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    short: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

  open_drawer: true

  open_css:
    top: ''
    left: ''

  constructor: (options={}) ->
    super
    @original_backbone_sync = Backbone.sync
    Backbone.sync = @sync

    root._fellrace = @
    $.notify = (type, argument) =>
      @vent.trigger(type, argument)

    $(document).ajaxSend @sendAuthenticationHeader
    Backbone.Marionette.Renderer.render = @render

    @addRegions @regions
    @actionRegionSetup()

    @_config = new FellRace.Config(options.config)
    @_api_url = @config("api_url")
    @_domain = @config("domain")
    Stripe?.setPublishableKey @config("stripe_publishable_key")

    @session = new FellRace.Models.UserSession()
    @race_publications = new FellRace.Collections.RacePublications([])
    @race_publications.fetch(remove: false)

    @future_instances = new FellRace.Collections.PublicFutureInstances([])
    @past_instances = new FellRace.Collections.PublicPastInstances([])
    @future_instances.fetch()
    @past_instances.fetch()

    @clubs = new FellRace.Collections.Clubs([])
    @categories = new FellRace.Collections.Categories([])
    @categories.fetch()

    @mapView = new FellRace.Views.Map()
    @gmapRegion.show @mapView
    @user_controlsRegion.show new FellRace.Views.UserControls()
    @listenToToggle()

    @noticeRegion.show new Notifier model: @vent, wait: 4000
    @session.load()
    @router = new FellRace.BaseRouter
    @content = $('#content')
    view = $(window)

    Backbone.history.start
      pushState: true
      root: '/'

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

  moveMapTo: (model,zoom) =>
    @mapView.moveTo model, zoom

  showRace: (race) =>
    @mapView.showRace race

  indexMapView: =>
    @mapView.indexView()

  publicMapView: =>
    @mapView.publicView()

  adminMapView: =>
    @mapView.adminView()

  toPublicOrHome: =>
    _fellrace.navigate Backbone.history.fragment.match(/admin(.+)/)?[1] || "/"

  #TODO: This should be in a subclass of Region
  #
  actionRegionSetup: =>
    @actionRegion
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
        @actionRegion.close()
      else if code is 13
        @actionRegion.currentView.trigger("submit") if @actionRegion.currentView

  closeRight: =>
    @extraContentRegion.close()

  config: (key) =>
    @_config.get(key)

  getCategories: () =>
    @categories

  ## Overrides
  #
  # We take over rendering to use our JST templates, which are in fact haml_coffee.
  #
  render: (template, data) ->
    if template
      path = "templates/#{template}"
      throw("Template '" + path + "' not found!") unless JST[path]
      JST[path](data)
    else
      ""

  user_actions: =>
    #TODO: intervene whenever someone is signed in but not confirmed.
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

  getMap: =>
    @mapView?.getMap()

  setMapOptions: (opts) =>
    @mapView?.setOptions(opts)

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
