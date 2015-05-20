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
      observe: "paid"
      onGet: "onlineOrPostal"
    ".club_name":
      observe: "club_name"

  onRender: =>
    @stickit()

  competitorUrl: (id) -> "/runners/#{id}"
  name: ([fore,middle]=[]) -> if middle then "#{fore} #{middle}" else fore
  onlineOrPostal: (paid) -> if paid then "online" else "postal"
  clubUrl: (id) -> "/clubs/#{id}" if id

class FellRace.Views.UncancelledAdminEntryRow extends FellRace.Views.AdminEntryRow
  template: "entries/admin_row"
  events:
    "click a.cancel": "cancelEntry"

  cancelEntry: =>
    @model.set {cancelled: true},
      persistChange: true


class FellRace.Views.AdminEntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.UncancelledAdminEntryRow
  template: "entries/admin_table"
  tagName: "table"
  itemViewContainer: "tbody"


class FellRace.Views.CancelledAdminEntryRow extends FellRace.Views.AdminEntryRow
  template: "entries/cancelled_admin_row"

  events:
    "click a.reinstate": "reinstateEntry"

  reinstateEntry: =>
    @model.set {cancelled: false},
      persistChange: true


class FellRace.Views.AdminCancelledEntriesTable extends FellRace.Views.AdminEntriesTable
  itemView: FellRace.Views.CancelledAdminEntryRow

