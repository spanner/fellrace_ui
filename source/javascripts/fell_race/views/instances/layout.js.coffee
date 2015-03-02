class FellRace.Views.InstanceLayout extends FellRace.Views.LayoutView
  routes: () =>
    "(/)": @default
    "splits(/)": @splits

  default: =>
    if @model.inFuture()
      view = new FellRace.Views.FutureInstance
        model: @model
    else
      @model.set show_splits: false
      view = new FellRace.Views.InstanceResults
        model: @model
    _fellrace.extraContentRegion.show view

  splits: (path) =>
    @model.set show_splits: true
    _fellrace.content.addClass "collapsed"
    view = new FellRace.Views.InstanceResults
      model: @model
    _fellrace.extraContentRegion.show view
