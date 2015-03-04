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

  onRender: () =>
    @stickit()
    if _fellrace.userSignedIn()
      @_entry = @model.entries.add({})
      @_entry_view = new FellRace.Views.NewEntry
        model: @_entry
        el: @$el.find("section.entry")
      @_entry_view.render()
    else
      $.notify "flash","Please sign in first."
      _fellrace.user_actions().signIn(destination_url:"/races/#{@model.get("race_slug")}/#{@model.get("name")}/enter")

  racePublicationUrl: (slug) =>
    "/races/#{slug}"
