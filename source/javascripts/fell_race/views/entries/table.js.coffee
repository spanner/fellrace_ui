class FellRace.Views.EntryRow extends Backbone.Marionette.ItemView
  template: "entries/row"
  className: "entry"
  tagName: "tr"

  events:
    "click a.cancel": "withdraw"

  bindings:
    ":el":
      observe: "cancelled"
      visible: "untrue"
    "a.name":
      attributes: [
        {
          observe: "competitor_id"
          name: "href"
          onGet: "competitorUrl"
        }
      ]
    "a.cancel":
      observe: "permissions"
      visible: true
      onGet: ({can_update:can_update}={}) -> can_update
    "span.fore": 
      observe: "forename"
    "span.middle": 
      observe: "middlename"
    "span.sur": 
      observe: "surname"
    "td.club": "club_name"
    "td.cat": "category_name"

  onRender: =>
    @stickit()
    @$el.addClass('postal') if @model.get('accepted')

  competitorUrl: (id) ->
    "/runners/#{id}"

  clubUrl: (id) ->
    "/clubs/#{id}" if id

  rowClass: (value) =>
    cssclass = "entry"
    cssclass << " postal" if value
    cssclass

  untrue: (val) -> !val

  withdraw: =>
    if confirm "Cancel #{@model.get("forename")} #{@model.get("surname")}'s entry for #{@model.get("race_name")} #{@model.get("instance_name")}?"
      @model.save(cancelled:true).done =>
        @model.collection.remove @model

class FellRace.Views.EntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.EntryRow
  template: "entries/table"
  itemViewContainer: "tbody"
