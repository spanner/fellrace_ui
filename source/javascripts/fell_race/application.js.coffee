FellRace = {}
FellRace.Models = {}
FellRace.Collections = {}
FellRace.Views = {}

root = exports ? this
root.FellRace = FellRace

class FellRace.AppRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    "": "indexMapView"
    "races": ""
    "races/:race_id": "publicMapView"
    "admin/races/:race_id": "adminMapView"
    "reset_password/": "resetPassword"
    "sign_out": "signOut"
    "sign_in": "signIn"
    "sign_up": "signUp"
    
    
    
    
    


class FellRace.Application extends Backbone.Marionette.Application

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

    @_config = new FellRace.Config(options.config)
    @_api_url = @config("api_url")
    @_domain = @config("domain")
    Stripe?.setPublishableKey @config("stripe_publishable_key")

    @session = new FellRace.Models.UserSession
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
  # move actions into a session view
  # wait for map to load
  onStart: =>
    @ui = new FellRace.Views.Ui
      el: @el
    @_router = new FellRace.AppRouter
      controller: @ui
    # @session.load()

    # @router = new FellRace.BaseRouter
    @content = $('#content')
    Backbone.history.start
      pushState: true
      root: '/'

  offsetX: =>
    if @open_drawer
      -(@content.width() - 10) / 2
    else
      -10 / 2

  closeRight: =>
    @extraContentRegion.close()

  config: (key) =>
    @_config.get(key)

  getCategories: () =>
    @categories

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

  render: (template, data) ->
    if template
      path = "templates/#{template}"
      throw("Template '" + path + "' not found!") unless JST[path]
      JST[path](data)
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