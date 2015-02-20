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
    @session = new FellRace.Models.UserSession()
    @race_publications = new FellRace.Collections.RacePublications([])

    # ???
    @clubs ?= new FellRace.Collections.Clubs([])
    @competitors ?= new FellRace.Collections.Competitors([])

    @mapView = new FellRace.Views.Map()
    @gmapRegion.show @mapView

    @user_controlsRegion.show new FellRace.Views.UserControls()

    @listenToToggle()

    @noticeRegion.show new Notifier model: @vent, wait: 4000

    @session.load()

    @router = new FellRace.BaseRouter

    @content = $('#content')
    view = $(window)
    @aspect_ratio = view.height() / view.width()
    view.on "resize", =>
      @aspect_ratio = view.height() / view.width()
      @resizeContent()

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
      @open_drawer = !@open_drawer
      @resizeContent(animate:true)

  secondsToString: (totalSeconds) =>
    if totalSeconds
      hours = Math.floor(totalSeconds / 3600)
      totalSeconds %= 3600
      minutes = Math.floor(totalSeconds / 60)
      minutes = "0#{minutes}" if minutes < 10
      seconds = totalSeconds % 60
      seconds = "0#{seconds}" if seconds < 10
      string = "#{minutes}:#{seconds}"
      string = "#{hours}:#{string}" if hours > 0
      string

  stringToSeconds: (string) =>
    if string
      [s,m,h] = string.split(":").reverse()
      seconds = (parseInt(s,10)||0) + 60 * (parseInt(m,10)||0) + 3600 * (parseInt(h,10)||0)

  offsetX: =>
    if @isPortrait()
      0
    else
      if @open_drawer
        -(@content.width() - 10) / 2
      else
        -10 / 2

  offsetY: =>
    if @isPortrait()
      @content.height() / 2        
    else
      0

  moveMapTo: (model) =>
    @mapView.moveTo model

  showRace: (race) =>
    @mapView.showRace race

  publicView: =>
    @mapView.showRacePublications()
    @mapView.removeRace()

  adminView: =>
    @mapView.hideRacePublications()

  resizeContent: ({animate:animate}={}) =>
    # TODO .animate then .css when animate==true
    css =
      top: ''
      left: ''
    unless @open_drawer
      if @isPortrait()
        css.top = $(window).height() - 10
      else
        css.left = - (@content.width() - 10)
    @content.css css

  isPortrait: =>
    @aspect_ratio > 1

  actionRegionSetup: =>
    @actionRegion
      .on "show", (view) ->
        @$el.show()
        @$el.find("a.cancel").on "click", =>
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

  ## Overrides
  #
  # We take over rendering to use our JST templates, which are in fact haml_coffee.
  #
  render: (template, data) ->
    path = "templates/#{template}"
    if template?
      throw("Template '" + path + "' not found!") unless JST[path]
      JST[path](data)
    else
      ""

  user_actions: =>
    resetPassword: (uid, token) =>
      @actionRegion.show(new FellRace.Views.SessionPasswordForm({uid: uid, token: token}))
    requestReset: =>
      @actionRegion.show(new FellRace.Views.SessionResetForm())
    signOut: =>
      @session.reset()
      @navigate('/', trigger:true)
    signUp: =>
      @actionRegion.show(new FellRace.Views.UserSignupForm())
    signUpForEvent: =>
      @actionRegion.show(new FellRace.Views.UserSignupFormForEvent())
    signIn: =>
      @actionRegion.show(new FellRace.Views.SessionLoginForm())
    confirm: (uid, token) =>
      @actionRegion.show(new FellRace.Views.SessionConfirmationForm({uid: uid, token: token}))
    reconfirm: =>
      @actionRegion.show(new FellRace.Views.SessionReconfirmationForm())
    signedUp: =>
      $.notify "success", "User account created"
      @actionRegion.close()
    hideAction: =>
      @actionRegion.close()

  getMap: =>
    @mapView?.getMap()

  setMapOptions: (opts) =>
    @mapView?.setOptions(opts)

  currentUser: =>
    @session.user

  userSignedIn: =>
    @session.signedIn()

  getCurrentCompetitor: =>
    @currentUser()?.getCompetitor()

  navigate: (route, {trigger:trigger,replace:replace}={}) =>
    trigger ?= true
    replace ?= false
    @vent.off "login:changed"
    Backbone.history.navigate route,
      trigger:trigger
      replace:replace

  sendAuthenticationHeader: (e, request) =>
    if token = @session?.authToken()
      request.setRequestHeader("Authorization", "Token token=#{token}")
