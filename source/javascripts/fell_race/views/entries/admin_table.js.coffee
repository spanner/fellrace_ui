class FellRace.Views.AdminEntryRow extends Backbone.Marionette.ItemView
  className: "entry"
  tagName: "tr"

  bindings:
    "a.name":
      attributes: [
        observe: "competitor_id"
        name: "href"
        onGet: "competitorUrl"
      ]
    "span.fore": "forename"
    "span.middle": "middlename"
    "span.sur": "surname"
    "span.cat": "category"
    "span.paid_or_accepted":
      attributes: [
        name: "class"
        observe: "paid"
        onGet: "onlineOrPostal"
      ]
    ".club_name":
      observe: "club_name"

  onRender: =>
    @stickit()

  competitorUrl: (id) -> 
    "/runners/#{id}"

  name: ([fore,middle]=[]) -> 
    if middle then "#{fore} #{middle}" else fore

  onlineOrPostal: (paid) -> 
    if paid then "online" else "postal"

  clubUrl: (id) -> 
    "/clubs/#{id}" if id


class FellRace.Views.NoEntryRow extends FellRace.Views.AdminEntryRow
  template: "entries/no_entry_row"


class FellRace.Views.UncancelledAdminEntryRow extends FellRace.Views.AdminEntryRow
  template: "entries/admin_row"
  events:
    "click a.withdraw": "cancelEntry"

  cancelEntry: =>
    @model.save cancelled: true


class FellRace.Views.AdminEntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.UncancelledAdminEntryRow
  emptyView: FellRace.NoEntryRow
  template: "entries/admin_table"
  tagName: "table"
  itemViewContainer: "tbody"


class FellRace.Views.CancelledAdminEntryRow extends FellRace.Views.AdminEntryRow
  template: "entries/cancelled_admin_row"
  events:
    "click a.reinstate": "reinstateEntry"

  reinstateEntry: =>
    @model.save cancelled: false


class FellRace.Views.AdminCancelledEntriesTable extends FellRace.Views.AdminEntriesTable
  itemView: FellRace.Views.CancelledAdminEntryRow

