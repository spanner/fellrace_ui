FellRace = {}
FellRace.Models = {}
FellRace.Collections = {}
FellRace.Views = {}

root = exports ? this
root.FellRace = FellRace


class FellRace.Application extends Marionette.Application
  region: "#ui"

  months:
    full: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    short: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

  initialize: (opts={}) ->
    root._fr = @
    @original_backbone_sync = Backbone.sync
    Backbone.sync = @sync
    Marionette.setRenderer @render
    $(document).ajaxSend @sendAuthenticationHeader

    @_config = new FellRace.Config
    @_radio = Backbone.Radio.channel('fell_race')
    @_api_url = @config("api_url")
    @_domain = @config("domain")
    Stripe?.setPublishableKey @config("stripe_publishable_key")

  onBeforeStart: =>
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

  onStart: =>
    @_ui = new FellRace.Views.UILayout
      model: @_session
    @showView @_ui
    @router = new FellRace.AppRouter(ui: @_ui)
    Backbone.history.start
      pushState: true
      root: '/'
    $(document).on "click", "a:not([data-bypass])", @handleLinkClick

  config: (key) =>
    @_config.get(key)

  getCategories: () =>
    @categories

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


  ## UI pass-through
  #
  offsetX: =>
    @ui.offsetX()

  user_actions: =>
    @ui.user_actions()


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

  handleLinkClick: (e) ->
    href = $(@).attr("href")
    if href and href[0] isnt "#" and href.slice(0, 4) isnt 'http' and href.slice(0, 6) isnt 'mailto'
      e.preventDefault()
      has_target = _.includes(href, "#")
      _fr.navigate href, trigger: !has_target           # `this` would be the link, so we call _fr

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


  ## Logging
  #
  logging: () =>
    !!@_logging

  startLogging: =>
    @_logging = true

  stopLogging: =>
    @_logging = false

  startComplaining: =>
    @_config.set 'report_errors', true
    @_config.set 'trap_errors', false

  stopComplaining: =>
    @_config.set 'report_errors', false
    @_config.set 'trap_errors', true


  ## Notification
  #
  broadcast: (event_type, argument) =>
    @_radio.trigger event_type, argument

  reportError: (message, source, lineno, colno, error) =>
    if error is "not_allowed"
      @complain('<p><strong>' + t('problems.not_allowed') + '</strong>.' + t('notes.view_denied') + t('please_go_home') + '</p>', 100000)
      true
    else if error is "not_found"
      @complain('<p><strong>' + t('problems.not_found') + '</strong>.' + t('notes.item_denied') + t('please_go_home') + '</p>', 100000)
      true
    else
      complaint = "<strong>#{message}</strong> #{t('at')} #{source} #{t('line')} #{lineno} #{t('col')} #{colno}."
      if @config('report_errors')
        @notify complaint, 100000, null, 'error'
      # Honeybadger has to be webpacked in now
      # if @config('badger_errors')
      #   Honeybadger.notify error,
      #     message: complaint
      true if @config('trap_errors')

  confirm: (message, href) =>
    @notify message, 4000, href, 'confirmation'

  complain: (message, href) =>
    @notify message, 10000, href, 'error'

  warn: (message, href) =>
    @notify message, 10000, href, 'warning'

  notify: (html_or_text, duration=4000, href=null, notice_type='information') =>
    if @_ui_view
      @_notices.add
        message: html_or_text
        href: href
        duration: duration
        notice_type: notice_type
    else
      failure_notice = $('<div class="complete_failure" />').appendTo($("#notices"))
      failure_notice.html(html_or_text)

  log: =>
    if @logging() and console?.log?
      console.log "[FR]", arguments...

