class FellRace.Views.PublicationEntry extends Backbone.Marionette.ItemView
  template: 'publications/entry'
  className: "event"

  bindings:
    '#name':
      observe: 'name'
      attributes: [
        {
          name: "href"
          observe: "slug"
          onGet: (slug) ->
            "/events/#{slug}"
        }
      ]

  onRender: =>
    @stickit()
    races = @model.race_publications
    instances = []
    races.each (race) =>
      instances = instances.concat race.instances.future()
      
    @_future_instances = new FellRace.Collections.Instances(instances)
    if @_future_instances.length is 0
      _fellrace.navigate "/events/#{@model.get "slug"}"
    else
      view = new FellRace.Views.EntryInstances
        collection: @_future_instances
        el: @$el.find("#instances")
      view.render()
