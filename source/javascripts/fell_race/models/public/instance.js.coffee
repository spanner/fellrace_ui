class FellRace.Models.PublicInstance extends Backbone.Model
  initialize: (opts) ->
    @build()

  build: =>
    @entries = new FellRace.Collections.Entries(@get("entries"),instance:@)
    @performances = new FellRace.Collections.Performances @get("performances"), instance: @
    @rootPerformances()

    @entries.on "add remove reset", () =>
      @set total_entries: @entries.length

    _.each ["performances","entries"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data
        if collection is "performances"
          @rootPerformances()

    @buildWinner()

  rootPerformances: =>
    @performances.each (p) =>
      p.set
        race_slug: @get("race_slug")
        instance_name: @get("name")

  buildWinner: =>
    @winner = new FellRace.Models.Competitor(@get("winner"))
    @on "change:winner", (model,winner) =>
      @winner.clear()
      @winner.set winner

  getPerformancesCount: =>
    @get "performances_count"

  inFuture: =>
    if date = @getDate()
      date > Date.now()

  inPast: =>
    if date = @getDate()
      date < Date.now()

  getDate: =>
    if date = @get("date")
      Date.parse(date)
