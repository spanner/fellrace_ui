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

    "span.cat": "category"

    "span.paid_or_accepted":
      observe: "paid"
      onGet: "onlineOrPostal"

    "a.club":
      observe: "club_name"
      attributes: [
        observe: "club_id"
        name: "href"
        onGet: "clubUrl"
      ]
 
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

class FellRace.Views.AdminEntriesTable extends Backbone.Marionette.CompositeView
  itemView: FellRace.Views.AdminEntryRow
  template: "entries/admin_table"
  tagName: "table"
  itemViewContainer: "tbody"
