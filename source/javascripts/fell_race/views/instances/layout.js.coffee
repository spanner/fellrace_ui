class FellRace.Views.InstanceLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "splits(/)": @splits
    "enter(/)": @enter
    "my_entry(/)": @myEntry

  defaultUrl: =>
    "/races/#{@model.get("race_slug")}/#{@model.get("name")}"

  initialize: (opts) ->
    @_competitor = opts.competitor
    super

  default: =>
    if @_previous.route is "splits"
      @model.set show_splits: false
      _fellrace.content.removeClass "collapsed"
    else
      if @model.inFuture()
        view = new FellRace.Views.FutureInstance
          model: @model
      else
        view = new FellRace.Views.InstanceResults
          model: @model
          competitor: @_competitor
      _fellrace.extraContentRegion.show view
    @_previous =
      route: "default"

  splits: =>
    @model.set show_splits: true
    _fellrace.content.addClass "collapsed"
    unless @_previous.route is "default"
      view = new FellRace.Views.InstanceResults
        model: @model
        competitor: @_competitor
      _fellrace.extraContentRegion.show view
    @_previous =
      route: "splits"

  myEntry: =>
    if _fellrace.userSignedIn() and entry = _fellrace.getCurrentCompetitor().entries.findWhere(instance_id: @model.id)
      view = new FellRace.Views.MyEntry
        model: entry
      _fellrace.extraContentRegion.show view
      @_previous =
        route: "myEntry"
      _fellrace.vent.once "login:changed", =>
        _fellrace.navigate @defaultUrl()
    else if _fellrace.authPending()
      _fellrace.vent.once "login:changed", =>
        @myEntry()
    else
      _fellrace.navigate @defaultUrl()

  enter: =>
    if _fellrace.userSignedIn()
      if entry = _fellrace.getCurrentCompetitor().entries.findWhere(instance_id: @model.id)
        _fellrace.navigate "#{@defaultUrl()}/my_entry", replace:true
      else
        view = new FellRace.Views.InstanceEnter
          model: @model
        _fellrace.extraContentRegion.show view
        @_previous =
          route: "enter"
    else
      _fellrace.user_actions().signIn(destination_url:"#{@defaultUrl()}/enter", heading: "Sign in to enter race")
      _fellrace.navigate @defaultUrl(), replace:true
