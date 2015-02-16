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
    root._fellrace = @
    
    $.notify = (type, argument) =>
      @vent.trigger(type, argument)

    $(document).ajaxSend @sendAuthenticationHeader
    Backbone.Marionette.Renderer.render = @render

    @addRegions @regions
    @actionRegionSetup()

    @_config = new FellRace.Config(options.config)
    @_api_url = @config("api_url")
    @session = new FellRace.Models.UserSession()
    @races ?= new FellRace.Collections.Races([])

    # ???
    @clubs ?= new FellRace.Collections.Clubs([])
    @competitors ?= new FellRace.Collections.Competitors([])

    @mapView = new FellRace.Views.Map()
    @gmapRegion.show @mapView

    @user_controlsRegion.show new FellRace.Views.UserControls()

    @listenToToggle()

    @noticeRegion.show new Notifier model: @vent, wait: 4000

    @vent.on "login:changed", =>
      @events.fetch() if @userSignedIn()

    @session.load()

    @router = new FellRace.BaseRouter
      main_region: @mainRegion

    @content = $('#content')
    view = $(window)
    @aspect_ratio = view.height() / view.width()
    view.on "resize", =>
      @aspect_ratio = view.height() / view.width()
      @resizeContent()

    Backbone.history.start
      pushState: true
      root: '/'

  apiUrl: =>
    @_api_url

  listenToToggle: =>
    $("#view_toggle").on "click", =>
      @open_drawer = !@open_drawer
      @resizeContent(animate:true)

  secondsToTime: (totalSeconds) =>
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



  # event: (slug) =>
  #   event = @events.findOrAddBy slug: slug
  #   @mainRegion.show new FellRace.Views.Event(model: event)
  #   event.fetch
  #     success: =>
  #       @mapView.goToModel event
  #       @vent.once "login:changed", =>
  #         @event(slug)
  #       unless event.editable()
  #         $.notify "error", "You have to be logged in to make changes to this event"
  #         @navigate "/events/#{slug}"
  #     error: (model, error) =>
  #       if @userSignedIn()
  #         $.notify('error', "Can't edit that event.")
  #       else
  #         $.notify('flash', "To edit your events, you have to be signed in.")
  #       @navigate "/events/#{slug}"
  #
  # publication: (slug) =>
  #   publication = @publications.findOrAddBy slug: slug
  #   @vent.once "login:changed", =>
  #     @publication(slug)
  #   publication.fetch
  #     success: (a, b, c) =>
  #       @mainRegion.show new FellRace.Views.Publication(model: publication)
  #       @mapView.goToModel publication
  #     error: ->
  #       $.notify('error', "Error during initialisation.")
  #
  # preview: (slug) =>
  #   publication = @previews.findOrAddBy slug: slug
  #   publication.set preview: true
  #   @vent.once "login:changed", =>
  #     @preview(slug)
  #   publication.fetch
  #     success: =>
  #       @mainRegion.show new FellRace.Views.Publication(model: publication)
  #       @mapView.goToModel publication
  #     error: =>
  #       $.notify('error', "Error during initialisation.")
  #
  # competitor: (id) =>
  #   competitor = new FellRace.Models.Competitor(id: id)
  #   @vent.once "login:changed", =>
  #     @competitor(id)
  #   competitor.fetch
  #     success: =>
  #       @mainRegion.show(new FellRace.Views.Competitor(model: competitor))
  # competitors_index: =>
  #   @searchModel ?= new Backbone.Model()
  #   @mainRegion.show(new FellRace.Views.CompetitorsTable(
  #     collection: @competitors
  #     model: @searchModel))
  # competitor_merging: =>
  #   competitors = new FellRace.Collections.Competitors()
  #   competitors.url = "/api/competitors/merge_requests"
  #   @mainRegion.show(new FellRace.Views.CompetitorsMergeTable(collection: competitors))
  #   competitors.fetch()
  # edit_competitor: (id) =>
  #   competitor = @competitors.findOrAdd(id: id)
  #   @vent.once "login:changed", =>
  #     @competitor_views.edit(id)
  #   competitor.fetch
  #     success: =>
  #       if competitor.editable()
  #         @mainRegion.show(new FellRace.Views.CompetitorEdit(model: competitor))
  #       else
  #         $.notify "error", "You have to be logged in to make changes to this runner"
  #         @navigate "/runners/#{id}"
  # instance: (slug,race_slug,name) =>
  #   publication = @publications.findOrAddBy slug: slug
  #   publication.fetch
  #     success: (a, b, c) =>
  #       @mapView.goToModel publication
  #       if race_publication = publication.race_publications.findWhere(slug: race_slug)
  #         if instance = race_publication.instances.findWhere(name: name)
  #           console.debug instance
  #           @mainRegion.show(new FellRace.Views.PublishedInstance model:instance)
  #     error: ->
  #       $.notify('error', "Error during initialisation.")
  #
  # instance_admin: (slug,race_slug,name) =>
  #   event = new FellRace.Models.Event(slug:slug)
  #   event.fetch
  #     success: =>
  #       @mapView.goToModel event
  #       event.races.once "sync", =>
  #         if race = event.races.findWhere(slug: race_slug)
  #           race.instances.once "sync", =>
  #             if instance = race.instances.findWhere(name:name)
  #               @mainRegion.show(new FellRace.Views.Instance model:instance)
  #     error: =>
  #       $.notify('error', "Error during initialisation.")
  #
  # new_instance: (slug,race_slug) =>
  #   event = new FellRace.Models.Event(slug:slug)
  #   event.fetch
  #     success: =>
  #       @mapView.goToModel event
  #       event.races.once "sync", =>
  #         if race = event.races.findWhere(slug: race_slug)
  #           race.instances.once "sync", =>
  #             instance = race.instances.add({})
  #             @mainRegion.show(new FellRace.Views.Instance model:instance)
  #     error: =>
  #       $.notify('error', "Error during initialisation.")
  #
  # event_entry: (slug) =>
  #   if publication = @publications.findOrAddBy(slug: slug)
  #     publication.fetch
  #       success: =>
  #         @mainRegion.show new FellRace.Views.PublicationEntry(model: publication)
  #         @mapView.goToModel publication
  #       error: =>
  #         $.notify('error', "Error during initialisation.")
  #
  # show_club: (id) =>
  #   club = new FellRace.Models.Club(id: id)
  #   @mainRegion.show(new FellRace.Views.Club(model: club))
  #   club.fetch()
  # clubs_index: =>
  #   @mainRegion.show(new FellRace.Views.ClubsList(collection: @clubs))
  #   @clubs.fetch()
  #
  # resetPassword: (uid, token) =>
  #   @navigate "/"
  #   @user_actions().resetPassword(uid, token)
  # confirm_user: (uid, token) =>
  #   @navigate "/"
  #   @user_actions().confirm(uid, token)
  #
  # me: =>
  #   @mapView.index()
  #   @vent.once "login:changed", =>
  #     if @userSignedIn()
  #       @mainRegion.show(new FellRace.Views.Me())
  #       @user_actions().hideAction()
  #       @vent.once "login:changed", =>
  #         @navigate "/", trigger:true
  #     else
  #       @navigate "/", trigger:true
  #   if @userSignedIn()
  #     @mainRegion.show(new FellRace.Views.Me())
  #   else
  #     @user_actions().signIn()

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
