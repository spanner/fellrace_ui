class FellRace.Models.PublicInstance extends Backbone.Model
  initialize: (opts) ->
    @build()

  build: =>
    @entries = new FellRace.Collections.Entries(@get("entries"),instance:@)
    @performances = new FellRace.Collections.Performances @get("performances"), instance: @

    @entries.on "add remove reset", () =>
      @set total_entries: @entries.length

    _.each ["performances","entries"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data

    @buildWinner()

  setUrls: =>
    url_stem = @url
    @entries.url = "#{url_stem}/entries"
    @performances.url = "#{url_stem}/performances"

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
