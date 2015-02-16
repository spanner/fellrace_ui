class FellRace.Models.Performance extends FellRace.Model
  initialize: ->
    super
    @build()
    @collection?.on "sort", =>
      @set odd_or_even: if @collection.indexOf(@) % 2 then "odd" else "even"

  build: =>
    @buildInstance()
    @buildCompetitor()

  buildCompetitor: =>
    if @collection and @collection.competitor
      @competitor = @collection.competitor 
    else
      @competitor = new FellRace.Models.Competitor(@get("competitor"))
    @on "change:competitor", (model, competitor) =>
      @competitor.clear()
      @competitor.set competitor

  buildInstance: =>
    if @collection and @collection.instance
      @instance = @collection.instance
    else
      @instance = new FellRace.Models.Instance @get("instance")
    @on "change:instance", (model, instance) =>
      @instance.clear()
      @instance.set instance

  getRace: =>
    @instance.race

  instanceUrl: =>
    @instance.resultsUrl()

  getRaceName: =>
    @instance.getRaceName()

  getInstancePerformancesCount: =>
    @instance.getPerformancesCount()

  eventUrl: =>
    @instance.eventUrl()

  getEvent: =>
    @instance.getEvent()

  getEventHidden: =>
    @getEvent().get "hidden"
