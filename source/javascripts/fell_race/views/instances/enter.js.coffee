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
    _fellrace.vent.on "auth.change", @render

  onRender: () =>
    @stickit()
    if _fellrace.userConfirmed()
      @model.entries.url = "#{_fellrace.apiUrl()}/entries"
      @_entry = @model.entries.add(instance_id: @model.id)
      @_entry_view = new FellRace.Views.NewEntry
        model: @_entry
        el: @$el.find("section.entry")
      @_entry_view.render()
    else
      _fellrace.user_actions().requestConfirmation()

  racePublicationUrl: (slug) =>
    "/races/#{slug}"
