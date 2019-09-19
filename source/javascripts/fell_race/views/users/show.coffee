class FellRace.Views.User extends Backbone.Marionette.ItemView
  template: 'users/show'
  id: "user"

  onRender: =>
    competitor = @model.getCompetitor()
    competitor.fetch()
    competitor_view = new FellRace.Views.Competitor
      model: competitor
      el: @$el.find("#competitor")
    competitor_view.render()
