class Home.Models.Performance extends Backbone.Model
  initialize: ->
    @_instance = new Home.Models.Instance @get("instance")

  instanceUrl: =>
    @_instance.resultsUrl()

  getRaceName: =>
    @_instance.getRaceName()

  getInstancePerformancesCount: =>
    @_instance.getPerformancesCount()

  eventUrl: =>
    @_instance.eventUrl()