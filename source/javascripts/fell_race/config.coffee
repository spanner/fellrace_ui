Modernizr.addTest 'filereader', ->
  !!(window.File && window.FileList && window.FileReader)

Modernizr.addTest 'formdata', ->
  !!(window.FormData)

Modernizr.addTest 'dropbox', ->
  Dropbox? and Dropbox.isBrowserSupported()
  true

Modernizr.addTest 'ios6plus', ->
  ua = window.navigator.userAgent
  /iP(hone|od|ad)/.test(ua) and /[6789]_\d/.test(ua)


## Configuration
#
# This is a simple config-by-environment mechanism. It's only one level deep: 
# basically a list of default settings that can be overridden per-environment,
# and a place to detect in which environment we are running.
#
class FellRace.Config
  defaults: 
    api_url: "//api.fellrace.org.uk"
    domain: "fellrace.org.uk"
    logging: false
    stripe_publishable_key: "pk_live_dOxGZ6LC5I1womT8MgsDn3jB"
    bing_api_key: "ApY0qAIIkStmgyAoqcr-Iav2s1obEi-MHhyMkNyZDD6Z2b-gf3CLmHo7djH6968P"
    google_api_key: "AIzaSyBP7pXQfGfZOeIC33zcyFP_S2go1V1I4fw"
    osm_api_key: "09bbae460cca4ae8b400ef767d695903"

  development:
    api_url: "//api.fr.dev"
    domain: "fr.dev"
    logging: true
    stripe_publishable_key: "pk_test_orOZm4kTjBQOf5XB3RM01q0U"
    bing_api_key: "ApY0qAIIkStmgyAoqcr-Iav2s1obEi-MHhyMkNyZDD6Z2b-gf3CLmHo7djH6968P"
    google_api_key: "AIzaSyBP7pXQfGfZOeIC33zcyFP_S2go1V1I4fw"
    osm_api_key: "09bbae460cca4ae8b400ef767d695903"

  constructor: (options={}) ->
    options.environment ?= @guessEnvironment()
    @_settings = _.defaults options, @[options.environment], @defaults

  guessEnvironment: () ->
    prod = new RegExp(/fellrace\.org\.uk/)
    if prod.test(window.location.href)
      "production"
    else
      "development"

   settings: =>
     @_settings

   get: (key) =>
    @_settings[key]

   set: (key, value) =>
    @_settings[key] = value