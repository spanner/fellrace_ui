class FellRace.Views.AdminListedInstance extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "instance"
  events:
    'click a.delete': "delete"

  onRender: () =>
    @$el.find('.editable').editable()
    @stickit()

  delete: (e) =>
    e.preventDefault() if e
    @model.destroy()

  url: ([race_slug,name]=[]) =>
    "/admin/races/#{race_slug}/#{name}"

class FellRace.Views.AdminFutureListedInstance extends FellRace.Views.AdminListedInstance
  template: 'instances/admin_future_list_item'
  bindings:
    "a.name":
      observe: "name"
      attributes: [
        observe: ["race_slug","name"]
        name: "href"
        onGet: "url"
      ]
    "span.date":
      observe: "date"
      onGet: "date"
    "span.time":
      observe: "time"
      onGet: "time"
    "span.total_entries": 
      observe: ["online_entries","entries_count","entry_limit"]
      onGet: "summarise"

  summarise: ([online_entry,entries_count,entry_limit]=[]) ->
    string = ""
    if online_entry
      string = entries_count
      if entry_limit and entry_limit > 0
        string = "#{string} / #{entry_limit}"
      string = "#{string} entries"

  date: (date) =>
    moment(date).format("D MMMM YYYY") if date

  time: (time) =>
    "at #{time}" if time

class FellRace.Views.AdminPastListedInstance extends FellRace.Views.AdminListedInstance
  template: 'instances/admin_past_list_item'
  bindings:
    "a.name":
      observe: "name"
      attributes: [
        observe: ["race_slug","name"]
        name: "href"
        onGet: "url"
      ]
    "span.total": 
      observe: "performances_count"
      onGet: "summarise"

  summarise: (value, options) =>
    if !value?
      ""
    else
      "#{value} runners"


class FellRace.Views.AddPastInstance extends Backbone.Marionette.ItemView
  template: 'instances/add_results'
  tagName: "li"
  className: "note"

class FellRace.Views.AdminPastInstancesList extends Backbone.Marionette.CollectionView
  emptyView: FellRace.Views.AddPastInstance
  itemView: FellRace.Views.AdminPastListedInstance

class FellRace.Views.AdminFutureInstancesList extends Backbone.Marionette.CollectionView
  itemView: FellRace.Views.AdminFutureListedInstance
