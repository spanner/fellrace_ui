class FellRace.Models.Entry extends Backbone.Model
  initialize: ->
    @collection?.on "sort", =>
      @set odd_or_even: if @collection.indexOf(@) % 2 then "odd" else "even"
    @build()

  build: =>
    if @has("competitor")
      @competitor = new FellRace.Models.Competitor(@get("competitor"))
