class FellRace.Views.AdminListedInstance extends Backbone.Marionette.ItemView
  template: 'instances/admin_list_item'
  tagName: "li"
  className: "instance"
  events:
    'click a.delete': "delete"

  bindings:
    "a.name":
      observe: "name"
      attributes: [
        {
          observe: ["race_slug","name"]
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

  url: ([race_slug,name]=[]) =>
    "/races/#{race_slug}/#{name}/admin"

  isPast: (date) =>
    date and Date.parse(date) <= Date.now()

  isFuture: (date) =>
    date and Date.parse(date) > Date.now()

class FellRace.Views.AddInstance extends Backbone.Marionette.ItemView
  template: 'instances/add_results'
  tagName: "li"
  className: "note"

class FellRace.Views.AdminInstancesList extends Backbone.Marionette.CollectionView
  emptyView: FellRace.Views.AddInstance
  itemView: FellRace.Views.AdminListedInstance
