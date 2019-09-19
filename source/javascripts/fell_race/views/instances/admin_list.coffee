class FellRace.Views.AdminListedInstance extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "instance"
  events:
    'click a.delete': "delete"

  onRender: () =>
    @stickit()

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
    "span.splits":
      observe: "has_splits"
      visible: true

  summarise: (value, options) =>
    if !value? or value is 0
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
