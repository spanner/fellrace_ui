#= require modernizr
#= require hamlcoffee
#= require lib/extensions
#= require lib/utilities
#= require underscore
#= require backbone
#= require backbone.marionette
#= require backbone.notifications
#= require backgrid
#= require lunr
#= require backgrid-filter
#= require backgrid-select-all
#= require d3.v3

#= require_tree ../templates
#= require results
#= require_tree ./results/models
#= require_tree ./results/collections
#= require_tree ./results/views

window.Results = new Backbone.Marionette.Application()
Results.Models = {}
Results.Collections = {}
Results.Views = {}

Backbone.Marionette.Renderer.render = (template, data) ->
  if template?
    throw("Template '" + template + "' not found!") unless JST[template]
    JST[template](data)
  else
    ""

if $('html').attr('class') is "oldie"
  oldie = true

$.notify = (type, argument) ->
  Results.vent.trigger(type, argument)

Results.addRegions
  notice: '#notice'
  search: '#search'
  table: '#table'
  chart: '#chart'

Results.addInitializer (options) ->
  unless oldie
    Results.notice.show new Notifier model: Results.vent, wait: 4000

  race_instance = new Results.Models.Instance
    id: $("#table").attr "data-instance-id"

  race_instance.fetch
    success: () ->
      new Results.Views.Instance(model: race_instance).render()
    error: () ->
      $.notify('error', "Error during results initialisation.")

Results.domain = ->
  dc = new RegExp(/\.dev/)
  if dc.test(window.location.href)
    "fr.dev"
  else
    "fellrace.org.uk"

$ ->
  Results.start()
