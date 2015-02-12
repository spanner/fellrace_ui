class FellRace.Models.Link extends Backbone.Model
  defaults:
    title: null
    url: null

  initialize: () ->
    @wait_then_save = _.debounce @save, 500
    _.each @defaults, (value, key) =>
      @on "change:#{key}", () =>
        @wait_then_save()
