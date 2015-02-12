class FellRace.Models.Record extends Backbone.Model
  defaults:
    holder: null
    year: null
    label: null
    elapsed_time: null

  initialize: () ->
    @wait_then_save = _.debounce @save, 500
    _.each @defaults, (value, key) =>
      @on "change:#{key}", () =>
        @wait_then_save()
