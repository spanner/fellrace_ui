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
      _fr.content.removeClass "collapsed"
    else
      if @model.inFuture()
        view = new FellRace.Views.FutureInstance
          model: @model
      else
        view = new FellRace.Views.InstanceResults
          model: @model
          competitor: @_competitor
      _fr.extraContentRegion.show view
    @_previous =
      route: "default"

  splits: =>
    @model.set show_splits: true
    _fr.content.addClass "collapsed"
    unless @_previous.route is "default"
      view = new FellRace.Views.InstanceResults
        model: @model
        competitor: @_competitor
      _fr.extraContentRegion.show view
    @_previous =
      route: "splits"

  myEntry: =>
    if _fr.userSignedIn() and entry = _fr.getCurrentCompetitor().entries.findWhere(instance_id: @model.id)
      view = new FellRace.Views.MyEntry
        model: entry
      _fr.extraContentRegion.show view
      @_previous =
        route: "myEntry"
      _fr.vent.once "login:changed", =>
        _fr.navigate @defaultUrl()
    else if _fr.authPending()
      _fr.vent.once "login:changed", =>
        @myEntry()
    else
      _fr.navigate @defaultUrl()

  enter: =>
    if _fr.userSignedIn()
      if entry = _fr.getCurrentCompetitor().entries.findWhere(instance_id: @model.id)
        _fr.navigate "#{@defaultUrl()}/my_entry", replace:true
      else
        view = new FellRace.Views.InstanceEnter
          model: @model
        _fr.extraContentRegion.show view
        @_previous =
          route: "enter"
    else
      _fr.user_actions().signIn(destination_url:"#{@defaultUrl()}/enter", heading: "Sign in to enter race")
      _fr.navigate @defaultUrl(), replace:true
