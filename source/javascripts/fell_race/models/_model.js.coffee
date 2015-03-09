class FellRace.Model extends Backbone.Model

  initialize: ->
    @on "sync", =>
      @set saving:false
    if @isNew()
      @once 'sync', =>
        @updateable()
    else
      @updateable()
    @on "publish", @publish

  updateable: () =>
    @updateSoon ?= _.debounce @update, 800
    @on "change", (m, options) =>
      if options.stickitChange or options.mapstickChange or options.persistChange
        @trigger('updating')
        @updateSoon()

  toJSON: () =>
    root = @singular_name
    json = {}
    if @savedAttributes?
      json[root] = {}
      for att in @savedAttributes
        json[root][att] = @get(att)
    else
      json[root] = super
    json

  update: =>
    @off "updated failed", @update
    if @get("saving")
      @deferSave()
    else
      @save {saving:true},
        wait: false
        success: @updated
        error: @failed

  deferSave: =>
    @once "updated failed", @update

  updated: () =>
    @set saving:false
    @trigger('updated')

  failed: () =>
    @set saving:false
    @trigger('failed')
