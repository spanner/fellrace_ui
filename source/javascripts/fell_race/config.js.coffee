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
    api_url: "http://api.fellrace.org.uk"

  staging:
    api_url: "http://apis.fellrace.org.uk"

  development:
    api_url: "http://api.fr.dev/api"

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
