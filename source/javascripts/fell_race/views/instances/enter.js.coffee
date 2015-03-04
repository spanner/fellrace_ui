class FellRace.Views.InstanceEnter extends Backbone.Marionette.ItemView
  template: 'instances/enter'

  bindings:
    ".race_name": "race_name"
    ".instance_name": "name"

    "a.close, a.race_name":
      attributes: [
        name: "href"
        observe: "race_slug"
        onGet: "racePublicationUrl"
      ]

  initialize: ->
    if _fellrace.userSignedIn()
      @_competitor = _fellrace.getCurrentCompetitor()
      console.log "@_competitor", @_competitor
    else
      $.notify "flash","Please sign in first."
      _fellrace.user_actions().signIn(destination_url:"/races/#{@model.get("race_slug")}/#{@model.get("name")}/enter")

  onRender: () =>
    @stickit()

  racePublicationUrl: (slug) =>
    "/races/#{slug}"

