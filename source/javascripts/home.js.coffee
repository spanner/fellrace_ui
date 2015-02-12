#= require lib/extensions
#= require lib/utilities
#= require hamlcoffee
#= require tinycolor
#= require underscore
#= require underscore.string
#= require backbone
#= require backbone.marionette
#= require backbone.stickit
#= require markerwithlabel
#= require jquery.peity
#= require jquery.cookie
#= require jquery.complexify

#= require_tree ../templates/
#= require home
#= require ./home/router
#= require_tree ./home/models
#= require_tree ./home/collections
#= require_tree ./home/views


Backbone.Marionette.Renderer.render = (template, data) ->
  if template?
    throw("Template '" + template + "' not found!") unless JST[template]
    JST[template](data)
  else
    ""

window.Home = new Backbone.Marionette.Application()

Home.addRegions
  main_events: '#publications'
  user_panel: '#panel'
  user_events: '#events'

Home.Models = {}
Home.Collections = {}
Home.Views = {}
Home.Controller =
  index: =>
    Home.welcome()
  sign_in: =>
    Home.signIn()
  sign_out: =>
    Home.signOut()
  # sign_up: =>
  #   Home.signUp()
  confirm: (uid, token) =>
    Home.confirm(uid, token)
  reconfirm: (uid, token) =>
    Home.reconfirm()
  request_reset: () =>
    Home.requestReset()
  reset_password: (uid, token) =>
    Home.resetPassword(uid, token)
  competitor: (id) =>
    Home.showCompetitor(id)
  competitors: () =>
    Home.showCompetitors()
  claimCompetitor: (id) =>
    #TODO
  club: (id) =>
    Home.showClub(id)
  clubs: () =>
    Home.showClubs()
  me: =>
    # Home.welcome()
    # Home.showCompetitor(Home.currentUser())

Home.start = ->
  $(document).ajaxSend Home.sendAuthenticationHeader
  Home.setTopMargin()
  Home.title = $("#header h1")
  Home.session = new Home.Models.UserSession()
  Home.router = new Home.Router()
  Home.mapView = new Home.Views.Map()

  Home.clubs ?= new Home.Collections.Clubs([])
  Home.competitors ?= new Home.Collections.Competitors([])

  Home.publicationsList = new Home.Views.PublicationsList()
  Home.main_events.show(Home.publicationsList)

  Home.session.load()
  Backbone.history.start
    pushState: true
    root: '/'

## User-management
#
# The main role of this application - apart from listing races - is to manage the user session.
# The user_panel region is routed and all our confirmation, registration and signing in and out
# happens in that area.
#
# The status panel is always useful and loads on start. The others are lazy-loaded as required.
#
Home.welcome = ->
  Home.statusPanel ?= new Home.Views.UserStatusPanel()
  Home.user_panel.show(Home.statusPanel)
  Home.eventsList ?= new Home.Views.UserEventsList()
  Home.user_events.show(Home.eventsList)

Home.requestReset = ->
  Home.requestResetView ?= new Home.Views.SessionResetForm()
  Home.user_panel.show(Home.requestResetView)

Home.resetPassword = (uid, token) ->
  Home.resetPasswordView ?= new Home.Views.SessionPasswordForm({uid: uid, token: token})
  Home.user_panel.show(Home.resetPasswordView)

Home.confirm = (uid, token) ->
  Home.confirmationView ?= new Home.Views.SessionConfirmationForm({uid: uid, token: token})
  Home.user_panel.show(Home.confirmationView)

Home.reconfirm = ->
  Home.reconfirmationView ?= new Home.Views.SessionReconfirmationForm()
  Home.user_panel.show(Home.reconfirmationView)

Home.signIn = ->
  Home.loginView ?= new Home.Views.SessionLoginForm()
  Home.user_panel.show(Home.loginView)

Home.signOut = ->
  Home.session.reset()
  Home.navigate('/', true)

# Home.signUp = ->
#   Home.statusPanel ?= new Home.Views.UserStatusPanel()
#   Home.user_panel.show(Home.statusPanel)

Home.showCompetitor = (id) ->
  competitor = Home.competitors.findOrAdd(id: id)
  competitor.fetch
    success: =>
      Home.main_events.show(new Home.Views.Competitor(model: competitor))

Home.showCompetitors = ->
  Home.competitors ?= new Home.Collections.Competitors()
  Home.competitors.fetch()
  Home.main_events.show(new Home.Views.CompetitorsTable(collection: Home.competitors))

Home.showClub = (id) ->
  club = new Home.Models.Club(id: id)
  club.fetch
    success: =>
      Home.main_events.show(new Home.Views.Club(model: club))

Home.showClubs = ->
  Home.clubs ?= new Home.Collections.Clubs()
  Home.clubs.fetch()
  Home.main_events.show(new Home.Views.ClubsList(collection: Home.clubs))

Home.setTopMargin = () ->
  $("#content").css "margin-top", $(window).innerHeight()-60

Home.setTitle = (title) ->
  Home.title.text title

Home.domain = ->
  dc = new RegExp(/\.dev/)
  if dc.test(window.location.href)
    "fr.dev"
  else
    "fellrace.org.uk"

## Session management
#
# We always have a session object,
# which always has a user object,
# which may or may not be persisted or confirmed.
#
Home.currentUser = ->
  Home.session.user

Home.userSignedIn = ->
  Home.session.signedIn()

Home.sendAuthenticationHeader = (e, request) ->
  if token = Home.session?.authToken()
    request.setRequestHeader("Authorization", "Token token=#{token}")


## Navigation
#
# Relative navigation is always passed through Home.navigate.

Home.navigate = (route, trigger) ->
  trigger ?= true
  Backbone.history.navigate route,
    trigger: trigger

$(document).on "click", "a:not([data-bypass])", (e) ->
  href = $(@).attr("href")
  prot = @protocol + "//"
  if href and href.slice(0, prot.length) isnt prot
    e.preventDefault()
    Home.navigate href

$ ->
  Home.start()

  # $('#content').css('margin-top', $(window).height() - 250)
  $(document).scrollTop($(window).height() - 240)
