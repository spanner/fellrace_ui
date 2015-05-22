class FellRace.Collections.Categories extends Backbone.Collection
  model: FellRace.Models.Category
  url: ->
    "#{_fellrace.apiUrl()}/categories"
