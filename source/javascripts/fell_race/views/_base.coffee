#TODO More base views.
# There are no Layouts in Marionette 3: these should just be views.


class FellRace.View extends Marionette.View

  initialize: ->
    @_classname = @constructor.name
    @_radio = Backbone.Radio.channel('fell_race')

  onRender: () =>
    @triggerMethod 'ready', this

  log: (msgs...) =>
    _fr.log(@_classname, msgs...)


class FellRace.CollectionView extends Marionette.CollectionView

  initialize: ->
    @_classname = @constructor.name
    @_radio = Backbone.Radio.channel('fell_race')

  onRender: () =>
    @triggerMethod 'ready', this

  log: (msgs...) =>
    _fr.log(@_classname, msgs...)


class FellRace.Views.LayoutView extends Marionette.View
  routes: {}
  regions:
    main: "main"

  initialize: (opts={}) ->
    @_classname = @constructor.name
    @_radio = Backbone.Radio.channel('fell_race')
    @_router = new FellRace.ViewRouter
      view: this
      routes: _.result(this, 'routes')
    @log "→ initialize", opts
    @setPath opts.path

  setPath: (path) =>
    @log "→ setPath", path
    path ?= "/"
    unless path is @_path
      @_router.handle(path)
      @_path = path

  log: (msgs...) =>
    _fr.log(@_classname, msgs...)


class FellRace.Views.CollectionFilter extends FellRace.View
  template: false

  bindings:
    ":el": "term"

  initialize: ->
    @model = new Backbone.Model

  onRender: =>
    @stickit()
    matcher = (model, term) =>
      @$el.addClass "working"
      if term
        @collection.each (model) ->
          model.set unmatched: model.unmatches(term)
      else
        @clearMatches()
      @$el.removeClass "working"

    @model.on "change:term", _.debounce(matcher, 250)

  clearMatches: =>
    @collection.each (model) -> model.unset "unmatched"

  onBeforeDestroy: =>
    @clearMatches()

