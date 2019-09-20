class FellRace.Views.InstanceEnter extends FellRace.View
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
    @_radio.on "auth.change", @render

  onRender: () =>
    @stickit()
    if _fr.userConfirmed()
      @model.entries.url = "#{_fr.apiUrl()}/entries"
      @_entry = @model.entries.add(instance_id: @model.id)
      @_entry_view = new FellRace.Views.NewEntry
        model: @_entry
        el: @$el.find("section.entry")
      @_entry_view.render()
    else
      _fr.user_actions().requestConfirmation()

  racePublicationUrl: (slug) =>
    "/races/#{slug}"
