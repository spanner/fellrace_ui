class Results.Models.Checkpoint extends Backbone.Model
  urlRoot: "/api/checkpoints"
  defaults:
    name: "name"
    
  initialize: =>
    @save_soon = _.debounce @save, 500
    @on "change:name", (model, val, opts) =>
      @save_soon()


