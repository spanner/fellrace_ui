class FellRace.Views.ListedInstance extends Backbone.Marionette.ItemView
  template: 'instances/list_item'
  tagName: "li"
  className: "instance"
  events:
    'click a.delete': "delete"

  bindings:
    "a.name":
      observe: "race_name"
      attributes: [
        {
          name: "href"
          onGet: "url"
        }
      ]
    ".past":
      observe: "date"
      visible: "isPast"
    ".future":
      observe: "date"
      visible: "isFuture"
    "span.summary": "summary"
    "span.total_entries": 
      observe: ["entries_count","entry_limit"]
      onGet: "summariseEntries"
    "span.total": 
      observe: "performances_count"
      onGet: "summarise"

  onRender: () =>
    @$el.find('.editable').editable()
    @stickit()

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

  summarise: (value, options) =>
    if !value?
      ""
    else
      "#{value} runners"

  summariseEntries: ([count,limit]=[]) =>
    if limit
      "#{count||0}/#{limit} entries"
    else if count
      "#{count} entries"

  url: (name) =>
    "/events/#{@model.event.get("slug")}/#{@model.race.get("slug")}/#{name}/admin"

  isPast: (date) =>
    date and Date.parse(date) <= Date.now()

  isFuture: (date) =>
    date and Date.parse(date) > Date.now()

class FellRace.Views.InstancesList extends Backbone.Marionette.CollectionView
  emptyView: FellRace.Views.AddInstance
  itemView: FellRace.Views.ListedInstance
