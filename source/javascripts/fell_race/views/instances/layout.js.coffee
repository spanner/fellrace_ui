class FellRace.Views.InstanceLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "splits(/)": @splits
    "enter(/)": @enter

  initialize: (opts) ->
    @_competitor = opts.competitor
    super

  default: =>
    if @_previous.route is "splits"
      @model.set show_splits: false
      _fellrace.content.removeClass "collapsed"
    else
      console.log @model
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

  enter: =>
    view = new FellRace.Views.InstanceEnter
      model: @model
    _fellrace.extraContentRegion.show view
