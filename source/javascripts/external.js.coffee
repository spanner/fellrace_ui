#= require hamlcoffee
#= require vendor/jquery
#= require vendor/modernizr
#= require vendor/jquery.peity
#= require vendor/underscore
#= require vendor/underscore.string
#= require vendor/backbone
#= require vendor/backbone.marionette
#= require vendor/backbone.stickit
#= require vendor/backbone.mapstick
#= require vendor/latlon
#= require vendor/osgridref
#= require vendor/moment
#= require vendor/coordtransform

#= require lib/extensions
#= require lib/utilities
#= require lib/map_utilities
#= require lib/sortable

#= require_tree ./templates

#= require external/application
#= require external/models
#= require external/collections

#= require external/views/map

#= require fell_race/views/_views

#= require_tree ./external/views
#= require_self


$ ->
  _.mixin(_.str.exports())
  new FellRace.Application()
