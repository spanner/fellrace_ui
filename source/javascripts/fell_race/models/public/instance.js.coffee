class FellRace.Models.PublicInstance extends Backbone.Model

  initialize: (opts) ->
    console.log "init", 
    @build()

  build: =>
    @entries = new FellRace.Collections.Entries(@get("entries"),instance:@)
    @performances = new FellRace.Collections.Performances @get("performances"), instance: @
    @checkpoints = new FellRace.Collections.Checkpoints @get("checkpoints")
    @rootPerformances()

    for att in ["date", "postal_entry_opening", "postal_entry_closing", "online_entry_opening", "online_entry_closing"]
      date = @get(att)
      @set(att, Date.parse(date)) if date?

    @entries.on "add remove reset", () =>
      @set total_entries: @entries.length

    _.each ["performances","entries","checkpoints"], (collection) =>
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
    if date = @get("date")
      date > Date.now()

  inPast: =>
    if date = @get("date")
      date < Date.now()

  getDate: =>
    @get("date")
