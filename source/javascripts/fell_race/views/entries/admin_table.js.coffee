class FellRace.Views.AdminEntryRow extends Backbone.Marionette.ItemView
  template: "entries/admin_row"
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

    "span.cat": "category_name"

    "span.paid_or_accepted":
      observe: "paid"
      onGet: "onlineOrPostal"

    ".club_name":
      observe: "club_name"

    "a.club_name":
      observe: "club_id"
      visible: true
      attributes: [
        observe: "club_id"
        name: "href"
        onGet: "clubUrl"
      ]

    "span.club_name":
      observe: "club_id"
      visible: "untrue"

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

class FellRace.Views.AdminEntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.AdminEntryRow
  template: "entries/admin_table"
  tagName: "table"
  itemViewContainer: "tbody"
