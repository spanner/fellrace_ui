class FellRace.Models.Performance extends FellRace.Model
  initialize: ->
    super
    @collection?.on "sort", =>
      @set odd_or_even: if @collection.indexOf(@) % 2 then "odd" else "even"

  getRace: =>
    @instance.race
