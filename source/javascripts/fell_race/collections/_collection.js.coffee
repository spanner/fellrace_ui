class FellRace.Collection extends Backbone.Collection
  delegatedEvents: ['show', 'hide']

  initialize: (models, options) =>
    if options
      for key, val of options
        @[key] = val
    @setModelTriggers()

  setModelTriggers: () =>
    for event_name in @delegatedEvents
      do (event_name) =>
        @on event_name, () ->
          @map (model) ->
            model.trigger "collection:#{event_name}"
