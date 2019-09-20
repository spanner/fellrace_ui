#TODO More base views.
# There are no Layouts in Marionette 3: these should just be views.


class FellRace.View extends Marionette.View

  initialize: ->
    @_radio = Backbone.Radio.channel('fell_race')

  onRender: () =>
    @triggerMethod 'ready', this


class FellRace.CollectionView extends Marionette.CollectionView

  initialize: ->
    @_radio = Backbone.Radio.channel('fell_race')

  onRender: () =>
    @triggerMethod 'ready', this


class FellRace.Views.LayoutView extends Marionette.View
  routes: {}

  initialize: (opts={}) ->
    @_radio = Backbone.Radio.channel('fell_race')
    @_router = new FellRace.ViewRouter
      view: this
      routes: _.result(this, 'routes')

  setPath: (path) ->
    path ?= "/"
    @_router.handle(path)


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
