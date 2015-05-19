class FellRace.Views.AdminEntryRow extends Backbone.Marionette.ItemView
  template: "entries/admin_row"
  className: "entry"
  tagName: "tr"

  events:
    "click a.control": "toggleControls"
    "click a.cancel": "cancelEntry"
    "click a.reinstate": "reinstateEntry"

  bindings:
    ":el":
      classes:
        wait: "saving"
        cancelled: "cancelled"
    "a.name":
      attributes: [
        observe: "competitor_id"
        name: "href"
        onGet: "competitorUrl"
      ]
    "span.fore": "forename"
    "span.middle": "middlename"
    "span.sur": "surname"

    "span.cat": "category_name"

    "span.paid_or_accepted":
      observe: "paid"
      onGet: "onlineOrPostal"

    ".club_name":
      observe: "club_name"

    ".cancel,.edit":
      observe: "cancelled"
      visible: "untrue"

    ".reinstate":
      observe: "cancelled"
      visible: true

    "input.accepted":
      observe: "accepted"
      attributes: [
        observe: "paid"
        name: "disabled"
      ]

  onRender: =>
    @stickit()

  competitorUrl: (id) =>
    "/runners/#{id}"

  name: ([fore,middle]=[]) ->
    if middle then "#{fore} #{middle}" else fore

  onlineOrPostal: (paid) ->
    if paid
      "online"
    else
      "postal"

  clubUrl: (id) ->
    "/clubs/#{id}" if id

  untrue: (val) ->
    !val

  cancelEntry: =>
    @model.set {cancelled: true},
      persistChange: true

  reinstateEntry: =>
    @model.set {cancelled: false},
      persistChange: true

class FellRace.Views.AdminEntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.AdminEntryRow
  template: "entries/admin_table"
  tagName: "table"
  itemViewContainer: "tbody"
