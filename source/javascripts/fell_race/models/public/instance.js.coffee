class FellRace.Models.PublicInstance extends Backbone.Model

  initialize: (opts) ->
    @build()

  build: =>
    @entries = new FellRace.Collections.Entries _.filter(@get("entries"), (e) -> !e.cancelled), instance: @
    @performances = new FellRace.Collections.Performances @get("performances"), instance: @
    @checkpoints = new FellRace.Collections.Checkpoints @get("checkpoints")
    @rootPerformances()

    for att in ["date", "postal_entry_opening", "postal_entry_closing", "online_entry_opening", "online_entry_closing"]
      date = @get(att)
      @set(att, Date.parse(date)) if date?
      @on "change:#{att}", @setEntryFlags

    @entries.url = "#{@url()}/entries"
    @entries.on "add remove reset", () =>
      @set total_entries: @entries.length
      @count

    _.each ["performances","entries","checkpoints"], (collection) =>
      @on "change:#{collection}", (model,data) =>
        @[collection].reset data
        if collection is "performances"
          @rootPerformances()

    @setEntryFlags()
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

  setEntryFlags: =>
    now = new Date
    @set "online_entry_active", @get('online_entry') and @get("online_entry_opening") and @get("online_entry_closing") and (@get("online_entry_opening") < now < @get("online_entry_closing"))
    @set "postal_entry_active", @get('postal_entry') and !!@get('entry_form') and @get("postal_entry_opening") and @get("postal_entry_closing") and (@get("postal_entry_opening") < now < @get("postal_entry_closing"))

  inFuture: =>
    if datetime = @getDateTime()
      datetime > Date.now()

  inPast: =>
    if datetime = @getDateTime()
      datetime < Date.now()

  getDate: =>
    @get("date")

  # TODO proper datetime attribute asap
  getDateTime: =>
    if date = @getDate()
      datetime = new Date(date)
      if @get('time')
        time = _.map @get('time').split(':'), (t) -> parseInt(t, 10)
        datetime.setHours(time...)
      datetime

  ## Summary chart data

  setEntryCounts: =>
    @set total_count: @entries.length
    postal_count = 0
    online_count = 0
    club_counts = {}
    cat_counts = {}
    @entries.each (entry) ->
      club_counts[entry.get('club_name')] ?= 0
      club_counts[entry.get('club_name')] += 1
      cat_counts[entry.get('category')] ?= 0
      cat_counts[entry.get('category')] += 1
      if entry.get('paid')
        online_count += 1
      else
        postal_count += 1
    @set
      online_count: online_count
      postal_count: postal_count
    @updateEntryData()
    @updateCategoryData(cat_counts)
    @updateClubData(club_counts)

  updateEntryData: =>
    @set 'entry_data',
      labels: ["postal", "online", "available"]
      series: [
        @get('postal_count'),
        @get('online_count'),
        @get('entry_limit') - @get('total_count')
      ]

  updateCategoryData: (counts) =>
    [f_cats, m_cats] = _.partition @get('category_names'), (c) -> c[0] is 'F'
    # if we have more than one U category then they should be spliced
    # back in ascending same order. f_matches records the next offset.
    f_matches = m_matches = 0
    for c, i in f_cats
      f_cats.splice(f_matches++, 0, f_cats.splice(i, 1)[0]) if c[1] is 'U'
    for c, i in m_cats
      m_cats.splice(m_matches++, 0, m_cats.splice(i, 1)[0]) if c[1] is 'U'
    @set 'cat_data',
      labels: _.map f_cats, (c) -> c.substr(1) || 'S'
      series: [
        _.map f_cats, (c) -> 
          value: counts[c] ? 0
          meta: c
      ,
        _.map m_cats, (c) -> 
          value: counts[c] ? 0
          meta: c
      ]

  updateClubData: (counts) =>
    sorted_clubs = _.sortBy _.keys(counts), (k) -> -counts[k]
    top_clubs = sorted_clubs.splice(0, 20)
    total_others = sorted_clubs.reduce (t, s) -> 
      t + parseInt(counts[s], 10)
    , 0
    not_taken = @get('entry_limit') - @get('total_count')
    labels = top_clubs.concat(['Other', 'Available'])
    values = _.map(top_clubs, (k) -> counts[k]).concat([total_others, not_taken])
    @set 'club_data',
      labels: labels
      series: values
