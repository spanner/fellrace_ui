class Results.Collection extends Backbone.Collection
  delegatedEvents: ['show', 'hide']
  
  initialize: () ->
    @setModelTriggers()
  
  save: () =>
    @map (model) ->
      model.save
        patch: true
  
  setModelTriggers: () =>
    for event_name in @delegatedEvents
      do (event_name) =>
        @on event_name, () ->
          @map (model) ->
            model.trigger "collection:#{event_name}"
    
