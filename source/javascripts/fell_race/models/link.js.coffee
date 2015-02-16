class FellRace.Models.Link extends FellRace.Model
  defaults:
    title: null
    url: null

  initialize: () ->
    super
    @wait_then_save = _.debounce @save, 500
    _.each @defaults, (value, key) =>
      @on "change:#{key}", () =>
        @wait_then_save()

  jsonForPublication: =>
    id: @id
    title: @get("title")
    url: @get("url")