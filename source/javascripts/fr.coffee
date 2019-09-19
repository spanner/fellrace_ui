#= require vendor/jquery
#= require vendor/modernizr
#= require vendor/moment
#= require vendor/jquery.peity
#= require vendor/jquery.cookie
#= require vendor/jquery.complexify
#= require vendor/pikaday
#= require vendor/tinycolor
#= require vendor/underscore
#= require vendor/underscore.string
#= require vendor/backbone
#= require vendor/backbone.marionette
#= require vendor/backbone.stickit
#= require vendor/backbone.notifications
#= require vendor/backbone.mapstick
#= require vendor/backbone.validation
#= require vendor/medium-editor
#= require vendor/coordtransform
#= require vendor/latlon
#= require vendor/gridref
#= require vendor/papaparse
#= require vendor/autofill-event
#= require vendor/chartist
#= require vendor/chartist-plugin-tooltip

#= require lib/extensions
#= require lib/utilities
#= require lib/map_utilities
#= require lib/sortable

#= require_tree ./templates

#= require ./fell_race/application
#= require ./fell_race/app_router
#= require ./fell_race/view_router
#= require ./fell_race/config

#= require_tree ./fell_race/models
#= require_tree ./fell_race/collections
#= require_tree ./fell_race/views
#= require_self

$ ->
  _.mixin(_.str.exports())

  #TODO this should be async, and triggered by a callback when maps are loaded.
  # but for that to work we have to fix or discard mapstick.
  console.log "ok go"
  new FellRace.Application().start()
