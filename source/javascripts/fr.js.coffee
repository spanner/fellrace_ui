#TODO: get all these from yarn / node_modules
#TODO: add honeybadger, slim down everything else

#= require hamlcoffee

#= require jquery
#= require moment
#= require jquery.peity
#= require jquery.cookie
#= require jquery.complexify
#= require pikaday
#= require tinycolor
#= require underscore
#= require underscore.string
#= require backbone
#= require backbone.marionette
#= require backbone.stickit
#= require backbone.validation
#= require medium-editor
#= require coordtransform
#= require papaparse
#= require autofill-event
#= require chartist
#= require chartist-plugin-tooltip

#= require vendor/backbone.notifications
#= require vendor/backbone.mapstick
#= require vendor/latlon
#= require vendor/gridref


#= require lib/extensions
#= require lib/utilities
#= require lib/map_utilities
#= require lib/sortable

#= require_tree ./templates

#= require ./fell_race/application
#= require ./fell_race/router
#= require ./fell_race/config

#= require_tree ./fell_race/models
#= require_tree ./fell_race/collections
#= require_tree ./fell_race/views
#= require_self

$ ->
  _.mixin(_.str.exports())

  $(document).on "click", "a:not([data-bypass])", (e) ->
    unless @protocol is "mailto:"
      href = $(@).attr("href")
      if $(@).attr("data-window")
        e.preventDefault()
        window.open href
      else
        prot = @protocol + "//"
        if href and href.slice(0, prot.length) isnt prot
          e.preventDefault()
          _fr.navigate href

  #TODO this should be async, and triggered by a callback when maps are loaded.
  # but for that to work we have to fix or discard mapstick.
  console.log "ok go"
  new FellRace.Application().start()
