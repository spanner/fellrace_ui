class Home.Views.Competitor extends Backbone.Marionette.ItemView
  template: 'competitors/show'
  className: "competitor"

  bindings:
    ".claim":
      observe: "user_id"
      visible: (val) ->
        console.log Home.currentUser().hasCompetitor()
        !val and !Home.currentUser().hasCompetitor()
      attributes: [
        {
          name: "href"
          observe: "id"
          onGet: (id) =>
            "/runner/#{id}/claim"
        }
      ]

  onRender: =>
    Home.setTitle @model.getName()
    @stickit()

    @_performances = new Home.Collections.Performances()
    @_performances.url = "#{@model.url()}/performances"
    @_performances.fetch()

    performances_list = new Home.Views.PerformancesTable
      collection: @_performances
      el: @$el.find ".performances"
    if club = @model.get("club")
      @_club = Home.clubs.findOrAdd(club)
      unless @_club.has("name")
        @_club.fetch()

      club_link = new Home.Views.ClubLink
        model: @_club
        el: @$el.find ".club"

    performances_list.render()
    club_link.render()

  claim: =>
    if Home.currentUser().isNew()
      Home.signIn() # send instructions with 'sign in'
    else if !Home.currentUser().hasCompetitor()
      @model.claim()
